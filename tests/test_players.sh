#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/ui/colors.sh"
source "$REPO_ROOT/src/ui/cat.sh"
source "$REPO_ROOT/src/ui/box.sh"
source "$REPO_ROOT/src/ui/menu.sh"
source "$REPO_ROOT/src/engine/progress.sh"
source "$REPO_ROOT/src/engine/history.sh"
source "$REPO_ROOT/src/engine/players.sh"

echo "Testing player profiles: create, rename, delete..."

# ── Create ─────────────────────────────────────────────────

assert_ok "a new name creates a profile" create_player_profile "Ada"
assert_path_exists "the save is written" "$GAME_ROOT/.catgame/ada.progress"
assert_fails "a name that already has a save is not created twice" \
    create_player_profile "Ada"
assert_fails "a name that is nothing but spaces is refused" \
    create_player_profile "   "

create_player_profile "Grace" || true
CURRENT_STAGE=7
HINTS_USED=4
mark_lesson_complete "01_pwd"
remember_command "ls -la"

# ── Read ───────────────────────────────────────────────────

assert_eq "both players are listed" "2" "$(list_player_profiles | wc -l | tr -d ' ')"
# Grace was selected last, so Grace is the one to open on.
assert_eq "the most recently played name comes first" \
    "Grace" "$(list_player_profiles | head -1)"

summary="$(player_profile_summary "Grace")"
assert_eq "a summary says the stage and the lessons done" \
    "Stage 7 · 1 lesson · just now" "$summary"
assert_eq "a player who never played says so" \
    "not played yet" "$(time_ago 0)"
assert_fails "there is no summary for a name with no save" \
    player_profile_summary "nobody"

# A save is a shell file the game sources. A name carrying a quote or a $(
# would break the next load or be run by it.
assert_eq "a quote is dropped from a name" 'catx' "$(sanitize_player_name 'cat"x')"
assert_eq "a command substitution is dropped from a name" \
    'cat(whoami)' "$(sanitize_player_name 'cat$(whoami)')"
assert_eq "surrounding space is trimmed" 'cat' "$(sanitize_player_name '  cat  ')"

create_player_profile 'Eve"; echo pwned; #' || true
assert_eq "a name that tried to carry code is stored harmlessly" \
    'Eve; echo pwned; #' "$PLAYER_NAME"
reset_progress_state
load_progress
assert_eq "and it loads back as itself" 'Eve; echo pwned; #' "$PLAYER_NAME"
delete_player_profile 'Eve; echo pwned; #'

# ── Update ─────────────────────────────────────────────────

select_player_profile "Ada" || true
assert_ok "a profile can be renamed" rename_player_profile "Ada" "Ada Lovelace"
assert_fails "the old save is gone" test -e "$GAME_ROOT/.catgame/ada.progress"
assert_path_exists "the new save is there" "$GAME_ROOT/.catgame/ada_lovelace.progress"
assert_eq "the name inside the save moved too" \
    "Ada Lovelace" "$(progress_field "$GAME_ROOT/.catgame/ada_lovelace.progress" PLAYER_NAME)"
assert_eq "renaming the live profile moves the session with it" \
    "$GAME_ROOT/.catgame/ada_lovelace.progress" "$PROGRESS_FILE"
assert_eq "and the live name with it" "Ada Lovelace" "$PLAYER_NAME"
assert_eq "the pointer to the last player follows the rename" \
    "ada_lovelace" "$(read_last_player)"

# The history is named after the same slug, so it has to travel too.
select_player_profile "Grace" || true
init_command_history
remember_command "cd toys"
rename_player_profile "Grace" "Grace Hopper"
assert_path_exists "the command history follows the rename" \
    "$GAME_ROOT/.catgame/grace_hopper.history"
assert_fails "and does not stay behind under the old name" \
    test -e "$GAME_ROOT/.catgame/grace.history"

assert_fails "a rename onto a name that is taken is refused" \
    rename_player_profile "Grace Hopper" "Ada Lovelace"
assert_path_exists "and leaves the profile it refused to move" \
    "$GAME_ROOT/.catgame/grace_hopper.progress"
assert_fails "a rename to an empty name is refused" \
    rename_player_profile "Grace Hopper" "   "
assert_fails "a rename of a player who does not exist is refused" \
    rename_player_profile "nobody" "somebody"

# Renaming to another spelling of the same name keeps the same profile.
assert_ok "a name can be respelled in place" \
    rename_player_profile "Grace Hopper" "grace hopper"
assert_eq "and keeps its progress" "7" \
    "$(progress_field "$GAME_ROOT/.catgame/grace_hopper.progress" CURRENT_STAGE)"

# ── Delete ─────────────────────────────────────────────────

assert_ok "a profile can be deleted" delete_player_profile "grace hopper"
assert_fails "the save is gone" test -e "$GAME_ROOT/.catgame/grace_hopper.progress"
assert_fails "and the command history with it" \
    test -e "$GAME_ROOT/.catgame/grace_hopper.history"
assert_fails "deleting a player who does not exist is refused" \
    delete_player_profile "nobody"
assert_eq "the list is down to the one that is left" \
    "Ada Lovelace" "$(list_player_profiles)"

# ── The typed title screen ─────────────────────────────────
# What a piped session gets. Every operation has to be reachable without a
# terminal to draw a menu on.

create_player_profile "Bo" || true
names=()
mapfile -t names < <(list_player_profiles)

choose_player_by_typing "${names[@]}" >/dev/null <<< "1"
assert_eq "a number plays that save" "play" "$PLAYER_ACTION"
assert_eq "and picks the one at that position" "${names[0]}" "$PLAYER_CHOICE"

choose_player_by_typing "${names[@]}" >/dev/null <<< "Zoe"
assert_eq "a name that is not in the list still plays" "play" "$PLAYER_ACTION"
assert_eq "under that name" "Zoe" "$PLAYER_CHOICE"

choose_player_by_typing "${names[@]}" >/dev/null <<< "delete 2"
assert_eq "delete asks to delete" "delete" "$PLAYER_ACTION"
assert_eq "the one at that position" "${names[1]}" "$PLAYER_CHOICE"

choose_player_by_typing "${names[@]}" >/dev/null <<< "rename 1 Ada B"
assert_eq "rename asks to rename" "rename" "$PLAYER_ACTION"
assert_eq "the one at that position" "${names[0]}" "$PLAYER_CHOICE"
assert_eq "and carries the new name with it" "Ada B" "$PLAYER_RENAME_TO"

choose_player_by_typing "${names[@]}" >/dev/null <<< "delete 99"
assert_eq "a position that is not in the list does nothing" "" "$PLAYER_ACTION"

choose_player_by_typing "${names[@]}" >/dev/null <<< "quit"
assert_eq "quit quits" "quit" "$PLAYER_ACTION"

choose_player_by_typing "${names[@]}" >/dev/null < /dev/null
assert_eq "end of input plays the most recent save rather than hanging" \
    "play" "$PLAYER_ACTION"

# ── The arrow-key list ─────────────────────────────────────
# The keys, without a terminal to draw on. The rows are the players plus the
# "new adventurer" row at the foot of the list.

PLAYER_TOTAL=3
PLAYER_VISIBLE=3
PLAYER_FIRST=0
PLAYER_SELECTED=0
PLAYER_ACTION=""

player_menu_key "up" || true
assert_eq "up at the top stays at the top" "0" "$PLAYER_SELECTED"
player_menu_key "down" || true
player_menu_key "down" || true
player_menu_key "down" || true
assert_eq "down stops at the last row" "2" "$PLAYER_SELECTED"

assert_fails "enter ends the menu" player_menu_key "enter"
assert_eq "with the play action" "play" "$PLAYER_ACTION"
assert_fails "n ends the menu" player_menu_key "n"
assert_eq "with the new action" "new" "$PLAYER_ACTION"
assert_fails "r ends the menu" player_menu_key "r"
assert_eq "with the rename action" "rename" "$PLAYER_ACTION"
assert_fails "d ends the menu" player_menu_key "d"
assert_eq "with the delete action" "delete" "$PLAYER_ACTION"
assert_fails "q ends the menu" player_menu_key "cancel"
assert_eq "with the quit action" "quit" "$PLAYER_ACTION"

assert_eq "an unbound letter is returned as itself" "x" \
    "$(read_menu_key < <(printf 'x'))"

finish "Player profile tests"
