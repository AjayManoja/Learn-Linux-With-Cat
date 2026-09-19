#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/engine/checker.sh"

echo "Testing checker..."

# checker.sh resolves every path against SANDBOX_HOME, so the arguments are
# sandbox-relative, never absolute.
mkdir -p "$SANDBOX_HOME/Documents"
echo "hello cat" > "$SANDBOX_HOME/notes.txt"

assert_ok    "check_file_exists finds a file"          check_file_exists "notes.txt"
assert_fails "check_file_exists rejects a missing file" check_file_exists "nope.txt"
assert_ok    "check_dir_exists finds a directory"       check_dir_exists "Documents"
assert_fails "check_dir_exists rejects a missing dir"   check_dir_exists "Nowhere"
assert_ok    "check_file_missing passes when absent"    check_file_missing "nope.txt"
assert_fails "check_file_missing fails when present"    check_file_missing "notes.txt"
assert_ok    "check_file_content matches"               check_file_content "notes.txt" "hello cat"
assert_fails "check_file_content rejects a mismatch"    check_file_content "notes.txt" "hello dog"

cp "$SANDBOX_HOME/notes.txt" "$SANDBOX_HOME/notes_backup.txt"
assert_ok    "check_file_copied sees both files"        check_file_copied "notes.txt" "notes_backup.txt"

echo "snacks" > "$SANDBOX_HOME/cat_food.txt"
assert_fails "check_file_moved fails before the move"   check_file_moved "cat_food.txt" "snacks.txt"
mv "$SANDBOX_HOME/cat_food.txt" "$SANDBOX_HOME/snacks.txt"
assert_ok    "check_file_moved sees source gone"        check_file_moved "cat_food.txt" "snacks.txt"

# Lessons phrase locations the way the player sees them, so check_current_dir
# has to accept the virtual /home/catplayer root as well as a relative name.
CURRENT_GAME_DIR="$SANDBOX_HOME"
assert_ok    "check_current_dir accepts virtual home"   check_current_dir "/home/catplayer"
CURRENT_GAME_DIR="$SANDBOX_HOME/Documents"
assert_ok    "check_current_dir accepts a relative dir" check_current_dir "Documents"
assert_ok    "check_current_dir accepts a virtual path" check_current_dir "/home/catplayer/Documents"
assert_fails "check_current_dir rejects a wrong dir"    check_current_dir "Downloads"

LAST_COMMAND="cat welcome.txt"
assert_ok    "check_command_run matches last command"   check_command_run "cat welcome.txt"
assert_fails "check_command_run rejects another"        check_command_run "ls"

assert_ok    "check_command_output matches expected"    check_command_output "echo meow" "meow"
assert_fails "check_command_output rejects a mismatch"  check_command_output "echo meow" "woof"
# Calling this with one argument used to abort the whole game under `set -u`.
assert_ok    "check_command_output survives a missing expected argument" \
             check_command_output "echo meow"

finish "Checker tests"
