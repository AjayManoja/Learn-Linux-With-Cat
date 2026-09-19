#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/world/sandbox.sh"
source "$REPO_ROOT/src/world/filesystem.sh"

echo "Testing Stage 1..."

# create_sandbox takes the stage NUMBER; it builds the path as stage${n}.
PLAYER_NAME="testcat"
assert_ok "stage 1 sandbox created" create_sandbox 1
assert_path_exists "player home exists"      "$SANDBOX_HOME"
assert_path_exists "welcome.txt copied"      "$SANDBOX_HOME/welcome.txt"
assert_path_exists "notes.txt copied"        "$SANDBOX_HOME/notes.txt"
assert_path_exists "Documents copied"        "$SANDBOX_HOME/Documents"
assert_path_exists "projects copied"         "$SANDBOX_HOME/projects"

assert_fails "no stage template for 99" create_sandbox 99
assert_ok    "sandbox_exists is true once built" sandbox_exists

assert_fails "{{PLAYER}} placeholders substituted" \
    grep -rq "{{PLAYER}}" "$SANDBOX_ROOT"

populate_stage_files 1
assert_path_exists "system.log generated for the less lesson" "$SANDBOX_HOME/system.log"
assert_path_exists "junk.txt generated for the rm lesson"     "$SANDBOX_HOME/junk.txt"
assert_path_exists "hidden .bashrc generated for ls -la"      "$SANDBOX_HOME/.bashrc"
assert_ok "secret line hidden in system.log" \
    grep -q "Secret door" "$SANDBOX_HOME/system.log"

# The log is teaching material: a player learning to read timestamps should
# not be shown 02:63:65.
bad_times="$(grep -cE '[0-9]{2}:(6[0-9]|[7-9][0-9]):|:(6[0-9]|[7-9][0-9])\]' "$SANDBOX_HOME/system.log" 2>/dev/null || true)"
assert_eq "system.log timestamps are all valid times" "0" "$bad_times"

# The 'less' lesson is only worth playing if the log is long enough to scroll.
log_lines="$(wc -l < "$SANDBOX_HOME/system.log")"
if [[ "$log_lines" -gt 100 ]]; then
    pass "system.log is long enough to page through ($log_lines lines)"
else
    fail "system.log is only $log_lines lines"
fi

destroy_sandbox
assert_fails "sandbox_exists is false after destroy" sandbox_exists

assert_ok "reset_sandbox rebuilds the world" reset_sandbox 1
assert_path_exists "welcome.txt back after reset" "$SANDBOX_HOME/welcome.txt"

finish "Stage 1 tests"
