#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/ui/colors.sh"
source "$REPO_ROOT/src/ui/cat.sh"
source "$REPO_ROOT/src/world/sandbox.sh"
source "$REPO_ROOT/src/engine/safety.sh"
source "$REPO_ROOT/src/engine/checker.sh"

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
# show_cat is the real one: some of these checks assert on what it says.

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

# ── rm and the trash bin ───────────────────────────────────
# rm is the one command that destroys the player's work, and it is routed
# through safe_rm so deletions stay recoverable. It reported "No such file or
# directory" for files that existed, because the caller and safe_rm each
# prefixed the sandbox path.
unlock_commands "rm ls cat"
mkdir -p "$SANDBOX_HOME"
CURRENT_GAME_DIR="$SANDBOX_HOME"

echo "junk" > "$SANDBOX_HOME/junk.txt"
execute_in_sandbox "rm junk.txt" >/dev/null 2>&1 || true
assert_ok    "rm deletes a file that exists"  check_file_missing "junk.txt"
assert_ok    "rm keeps the file in the trash" test -e "${TRASH_DIR}/junk.txt"

# The message must name what the player typed, not the real sandbox path,
# which would leak where the game actually lives.
echo "gone" > "$SANDBOX_HOME/present.txt"
rm_output="$(execute_in_sandbox "rm missing.txt" 2>&1 || true)"
assert_ok    "rm reports the typed name for a missing file"     grep -qF "cannot remove 'missing.txt'" <<< "$rm_output"
assert_fails "rm does not leak the sandbox path"     grep -qF "$SANDBOX_HOME" <<< "$rm_output"

# Flags must not be mistaken for filenames, in any spelling.
mkdir -p "$SANDBOX_HOME/adir" && echo x > "$SANDBOX_HOME/adir/inner.txt"
execute_in_sandbox "rm -rf adir" >/dev/null 2>&1 || true
assert_ok "rm -rf removes a directory" check_file_missing "adir"

echo a > "$SANDBOX_HOME/one.txt"; echo b > "$SANDBOX_HOME/two.txt"
execute_in_sandbox "rm one.txt two.txt" >/dev/null 2>&1 || true
assert_ok "rm removes the first of several operands"  check_file_missing "one.txt"
assert_ok "rm removes the second of several operands" check_file_missing "two.txt"

# Containment still holds.
outside="${TEST_ROOT}/outside.txt"
echo "do not touch" > "$outside"
execute_in_sandbox "rm ../../outside.txt" >/dev/null 2>&1 || true
assert_ok "rm cannot reach outside the sandbox" test -e "$outside"

# ── Standing in a directory you just locked ────────────────
# Stage 3 hands the player chmod, so they can remove the execute bit from the
# directory they are standing in. Every command then failed at the cd, and
# `cd ..` failed with them, so the only way out was quitting the game.
mkdir -p "$SANDBOX_HOME/cellar"
echo "loot" > "$SANDBOX_HOME/cellar/box.txt"
CURRENT_GAME_DIR="$SANDBOX_HOME/cellar"
chmod 000 "$SANDBOX_HOME/cellar"

# Redirected to a file rather than captured with $( ), which would run the
# whole thing in a subshell and throw away the relocation being tested.
locked_out="${TEST_ROOT}/locked.out"
execute_in_sandbox "ls" > "$locked_out" 2>&1 || true

assert_eq "a locked current directory moves the player out"     "$SANDBOX_HOME" "$CURRENT_GAME_DIR"
assert_ok "the player is told which directory they locked"     grep -qF "/home/catplayer/cellar" "$locked_out"
assert_fails "the real sandbox path is never shown"     grep -qF "$SANDBOX_ROOT" "$locked_out"

# And the way back in is the command the message names.
execute_in_sandbox "chmod u+rwx cellar" >/dev/null 2>&1 || true
execute_in_sandbox "cd cellar" >/dev/null 2>&1 || true
assert_eq "the player can re-enter once they unlock it"     "$SANDBOX_HOME/cellar" "$CURRENT_GAME_DIR"

# Leaving a locked directory must not require entering it first.
chmod 000 "$SANDBOX_HOME/cellar"
CURRENT_GAME_DIR="$SANDBOX_HOME/cellar"
execute_in_sandbox "cd .." >/dev/null 2>&1 || true
assert_eq "cd .. escapes a locked directory" "$SANDBOX_HOME" "$CURRENT_GAME_DIR"

chmod 755 "$SANDBOX_HOME/cellar"
CURRENT_GAME_DIR="$SANDBOX_HOME"

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

# find -exec is terminated by a literal \; — refusing that makes the flag,
# and every lesson that teaches it, impossible to use.
assert_ok "allows the escaped semicolon find -exec needs"     sandbox_syntax_ok 'find . -name "*.md" -exec wc -l {} \;'
assert_ok "allows an escaped semicolon as an argument"     sandbox_syntax_ok 'echo hi \; there'
assert_fails "still refuses a bare semicolon after an escape elsewhere"     sandbox_syntax_ok 'find . -exec ls {} \; ; whoami'

# A command the gates refuse never ran, so it must not satisfy a lesson that
# checks what the player last typed.
CURRENT_GAME_DIR="$SANDBOX_HOME"
LAST_COMMAND="ls; whoami"
execute_in_sandbox "ls; whoami" >/dev/null 2>&1 || true
assert_eq "a refused command is not recorded as the last command" "" "$LAST_COMMAND"

LAST_COMMAND="cat /etc/passwd"
execute_in_sandbox "cat /etc/passwd" >/dev/null 2>&1 || true
assert_eq "a command refused for its path is not recorded either" "" "$LAST_COMMAND"

LAST_COMMAND="ls"
execute_in_sandbox "ls" >/dev/null 2>&1 || true
assert_eq "a command that ran is still recorded" "ls" "$LAST_COMMAND"

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
