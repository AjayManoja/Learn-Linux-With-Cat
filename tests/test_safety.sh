#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/world/sandbox.sh"
source "$REPO_ROOT/src/engine/safety.sh"

echo "Testing safety filter..."

# The blocklist is check_safety's whole job: reject commands that would reach
# outside the game, and leave ordinary lesson commands alone.
assert_fails "sudo blocked"          check_safety "sudo rm -rf /"
assert_fails "su blocked"            check_safety "su root"
assert_fails "dd blocked"            check_safety "dd if=/dev/zero of=/dev/sda"
assert_fails "mkfs blocked"          check_safety "mkfs.ext4 /dev/sda1"
assert_fails "shutdown blocked"      check_safety "shutdown -h now"
assert_fails "wget blocked"          check_safety "wget http://example.com"
assert_fails "curl blocked"          check_safety "curl http://example.com"
assert_fails "rm -rf / blocked"      check_safety "rm -rf /"
assert_fails "rm -fr / blocked"      check_safety "rm -fr /"
assert_fails "piped sudo blocked"    check_safety "echo hi | sudo tee /etc/hosts"

assert_ok    "normal rm allowed"     check_safety "rm file.txt"
assert_ok    "ls allowed"            check_safety "ls -la"
assert_ok    "cd allowed"            check_safety "cd Documents"
assert_ok    "cat allowed"           check_safety "cat notes.txt"

# Staying inside the sandbox is enforced by the cd handler, not the blocklist,
# so it has to be exercised where it actually lives.
source "$REPO_ROOT/src/engine/runner.sh"
show_cat() { :; }   # stub: the warning path draws a cat

mkdir -p "$SANDBOX_HOME/Documents"
CURRENT_GAME_DIR="$SANDBOX_HOME"

execute_in_sandbox "cd ../../etc" >/dev/null 2>&1 || true
assert_eq "cd ../../etc cannot escape the sandbox" "$SANDBOX_HOME" "$CURRENT_GAME_DIR"

execute_in_sandbox "cd /etc" >/dev/null 2>&1 || true
assert_eq "cd /etc cannot escape the sandbox" "$SANDBOX_HOME" "$CURRENT_GAME_DIR"

execute_in_sandbox "cd Documents" >/dev/null 2>&1 || true
assert_eq "cd into a real subdirectory works" "$SANDBOX_HOME/Documents" "$CURRENT_GAME_DIR"

execute_in_sandbox "cd .." >/dev/null 2>&1 || true
assert_eq "cd .. back to home works" "$SANDBOX_HOME" "$CURRENT_GAME_DIR"

# ── The syntax gate ────────────────────────────────────────
# Chaining and command substitution would route around the command
# allowlist, so they are refused — but only unquoted. Stage 5 has the player
# write shell code into files, where the same characters are just text.
assert_fails "refuses chained commands"        sandbox_syntax_ok "ls; whoami"
assert_fails "refuses &&"                      sandbox_syntax_ok "ls && whoami"
assert_fails "refuses ||"                      sandbox_syntax_ok "ls || whoami"
assert_fails "refuses command substitution"    sandbox_syntax_ok 'echo $(whoami)'
assert_fails "refuses backticks"               sandbox_syntax_ok 'echo `whoami`'

assert_ok "allows a pipe"                      sandbox_syntax_ok "grep ERROR log | wc -l"
assert_ok "allows redirection"                 sandbox_syntax_ok "cat file > out"
assert_ok "allows a background job"            sandbox_syntax_ok "sleep 300 &"
assert_ok "allows a quoted semicolon"          sandbox_syntax_ok "echo 'if [ -f x ]; then' >> s.sh"
assert_ok "allows a quoted pipe"               sandbox_syntax_ok "echo 'sort a | uniq -c' >> s.sh"
assert_ok "allows a semicolon inside a search" sandbox_syntax_ok "grep 'a;b' file.txt"

# ── Stage 4: the kill gate ─────────────────────────────────
# 'kill' takes a raw PID, so nothing but an explicit allowlist stops a player
# from stopping their own shell or editor.
mkdir -p "$SANDBOX_ROOT"
rm -f "$(game_pid_file)"

# No stage is loaded here, so nothing is unlocked yet; the executor would
# refuse 'kill' as an unknown command before the gate ever ran.
unlock_commands "kill sleep"

assert_fails "kill gate rejects PID 1"            pid_is_ours 1
assert_fails "kill gate rejects a non-number"     pid_is_ours "abc"
assert_fails "kill gate rejects an unknown PID"   pid_is_ours 999999

# A process this game started is fair game; one it did not is not.
sleep 60 >/dev/null 2>&1 &
ours_pid=$!
record_game_pid "$ours_pid"
assert_ok "kill gate accepts a job the game started" pid_is_ours "$ours_pid"

sleep 60 >/dev/null 2>&1 &
foreign_pid=$!
assert_fails "kill gate rejects a job the game did not start" pid_is_ours "$foreign_pid"

CURRENT_GAME_DIR="$SANDBOX_HOME"
mkdir -p "$SANDBOX_HOME"

execute_in_sandbox "kill $foreign_pid" >/dev/null 2>&1 || true
if kill -0 "$foreign_pid" 2>/dev/null; then
    pass "a foreign process survives 'kill' through the sandbox"
else
    fail "the sandbox killed a process the game did not start"
fi

assert_ok "list_game_pids sees the live job"     grep -qx "$ours_pid" <<< "$(list_game_pids)"

execute_in_sandbox "kill $ours_pid" >/dev/null 2>&1 || true
sleep 1
if kill -0 "$ours_pid" 2>/dev/null; then
    fail "the sandbox refused to kill its own job"
else
    pass "the game's own job is killable"
fi

kill "$foreign_pid" 2>/dev/null || true
wait 2>/dev/null || true

finish "Safety tests"
