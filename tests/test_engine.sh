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

# Entries are matched as globs, not regexes: the curriculum includes ">", "&",
# "$1" and "sort | uniq -c", and a regex match would both mis-fire and let
# duplicates through.
COMMANDS_PRACTICED=""
add_learned_command "sort | uniq -c"
add_learned_command "sort | uniq -c"
add_learned_command '$1'
add_learned_command '$1'
add_learned_command ""
assert_eq "commands with shell metacharacters are stored once" \
    'sort | uniq -c $1' "$(get_learned_commands)"

# ── Player profiles ────────────────────────────────────────
# Each name gets its own save. A shared save meant the second player to type
# their name resumed the first player's game under their own name.

assert_eq "names differing only in case and spacing share a profile" \
    "$(player_slug "Ada Lovelace")" "$(player_slug "ada_LOVELACE")"

select_player_profile "player001" || true
CURRENT_STAGE=5
HINTS_USED=9
mark_lesson_complete "01_pwd"

assert_fails "a name with no save is a new player" select_player_profile "player002"
assert_eq "a new player starts at stage 1"   "1"          "$CURRENT_STAGE"
assert_eq "a new player keeps their name"    "player002"  "$PLAYER_NAME"
assert_eq "a new player starts with no hints used" "0"    "$HINTS_USED"
assert_eq "a new player inherits no lessons" ""           "$COMPLETED_LESSONS"

assert_ok "a name with a save is a returning player" select_player_profile "player001"
assert_eq "a returning player resumes their stage" "5" "$CURRENT_STAGE"
assert_eq "a returning player keeps their hint count" "9" "$HINTS_USED"

# ── Learned commands are the curriculum, not the shell history ─
# Old saves recorded whatever was typed at the prompt. load_progress rebuilds
# the list from the lessons completed.

legacy_save="$GAME_ROOT/.catgame_progress"
cat > "$legacy_save" <<'EOF'
CURRENT_STAGE="2"
PLAYER_NAME="oldtimer"
COMMANDS_PRACTICED="pwd vsquit hi bash ./scripts/hello.sh"
COMPLETED_LESSONS="stage1:01_pwd stage1:03_ls_la stage2:04_grep"
COMPLETED_MISSIONS=""
EOF

assert_ok "an older single save is claimed by the player named in it" \
    select_player_profile "oldtimer"
assert_fails "the single save is gone once claimed" test -e "$legacy_save"
assert_eq "learned commands are rebuilt from completed lessons" \
    "pwd ls -la grep" "$(get_learned_commands)"

finish "Engine tests"
