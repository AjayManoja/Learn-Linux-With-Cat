#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/engine/progress.sh"

echo "Testing engine..."

PLAYER_NAME="testplayer"
CURRENT_STAGE=1
CURRENT_SECTION="B"
COMMANDS_PRACTICED="pwd ls"
save_progress
assert_path_exists "progress file written" "$GAME_ROOT/.catgame_progress"

# Clobber the live values first, otherwise a load that does nothing at all
# still looks like it worked.
PLAYER_NAME="wrong"
CURRENT_STAGE=99
CURRENT_SECTION="Z"
COMMANDS_PRACTICED=""
load_progress

assert_eq "player name restored"  "testplayer" "$PLAYER_NAME"
assert_eq "stage restored"        "1"          "$CURRENT_STAGE"
assert_eq "section restored"      "B"          "$CURRENT_SECTION"
assert_eq "practiced commands restored" "pwd ls" "$COMMANDS_PRACTICED"

rm -f "$GAME_ROOT/.catgame_progress"
load_progress
assert_path_exists "load_progress recreates a missing save" "$GAME_ROOT/.catgame_progress"

mark_lesson_complete "07_cat"
assert_eq "lesson marked complete in memory" "07_cat" "$CURRENT_LESSON"
CURRENT_LESSON=""
load_progress
assert_eq "lesson marked complete on disk" "07_cat" "$CURRENT_LESSON"

add_learned_command "grep"
assert_ok "learned command recorded" grep -q "grep" <<< "$(get_learned_commands)"

finish "Engine tests"
