#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/ui/colors.sh"
source "$REPO_ROOT/src/ui/cat.sh"
source "$REPO_ROOT/src/ui/box.sh"
source "$REPO_ROOT/src/engine/progress.sh"
source "$REPO_ROOT/src/engine/runner.sh"
source "$REPO_ROOT/src/engine/cheat.sh"

echo "Testing cheatcode stage jumping..."

# ── Reading the stage list ─────────────────────────────────

assert_eq "a stage's name is read without sourcing its conf" \
    "Cat's First Script" "$(stage_title 5)"

# Sourcing stage.conf here would replace the running stage's sections, which
# is exactly what stage_title must not do.
SECTION_A_LESSONS="canary"
stage_title 9 >/dev/null
assert_eq "reading a name leaves the current stage's config alone" \
    "canary" "$SECTION_A_LESSONS"

assert_fails "a stage that does not exist has no name" stage_title 99

stage_list="$(list_stage_numbers | tr '\n' ' ')"
assert_eq "the stage list starts at 1 and is contiguous" \
    "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 " "$stage_list"

# ── Keys ───────────────────────────────────────────────────

assert_eq "up arrow moves up"      "up"     "$(read_menu_key < <(printf '\e[A'))"
assert_eq "down arrow moves down"  "down"   "$(read_menu_key < <(printf '\e[B'))"
assert_eq "k moves up"             "up"     "$(read_menu_key < <(printf 'k'))"
assert_eq "j moves down"           "down"   "$(read_menu_key < <(printf 'j'))"
assert_eq "enter selects"          "enter"  "$(read_menu_key < <(printf '\n'))"
assert_eq "q cancels"              "cancel" "$(read_menu_key < <(printf 'q'))"
assert_eq "a bare escape cancels"  "cancel" "$(read_menu_key < <(printf '\e'))"
assert_eq "end of input cancels"   "cancel" "$(read_menu_key < /dev/null)"

assert_ok "the menu always leaves room for at least three rows" \
    test "$(cheat_menu_capacity)" -ge 3

# ── Moving the cursor ──────────────────────────────────────
# A 15-stage list in a 5-row window: the cursor must stay inside the list,
# and the window must follow it without moving when it does not have to.

MENU_TOTAL=15 MENU_VISIBLE=5 MENU_SELECTED=0 MENU_FIRST=0

assert_ok   "down keeps the menu open" cheat_menu_move down
assert_eq   "down moves the cursor"      "1" "$MENU_SELECTED"
assert_eq   "the window stays put while the cursor is inside it" "0" "$MENU_FIRST"

MENU_SELECTED=0 MENU_FIRST=0
cheat_menu_move up
assert_eq "up at the top of the list does nothing" "0" "$MENU_SELECTED"

MENU_SELECTED=4 MENU_FIRST=0
cheat_menu_move down
assert_eq "the cursor reaches the last visible row" "5" "$MENU_SELECTED"
assert_eq "the window scrolls to follow it"         "1" "$MENU_FIRST"

MENU_SELECTED=5 MENU_FIRST=5
cheat_menu_move up
assert_eq "scrolling back up follows the cursor too" "4" "$MENU_FIRST"

MENU_SELECTED=14 MENU_FIRST=10
cheat_menu_move down
assert_eq "down at the end of the list does nothing" "14" "$MENU_SELECTED"
assert_eq "and the window does not scroll past it"   "10" "$MENU_FIRST"

assert_fails "enter closes the menu"  cheat_menu_move enter
assert_fails "cancel closes the menu" cheat_menu_move cancel

# ── Drawing ────────────────────────────────────────────────

# A 9-stage list, showing 5 rows starting at index 2 (stages 3-7), with the
# cursor on the last of them.
CURRENT_STAGE=4
COMPLETED_STAGES="1 2 3"
menu_frame="$(draw_cheat_menu 6 2 5 1 2 3 4 5 6 7 8 9)"

assert_ok "the cursor marks the selected stage" \
    grep -qE -- "-> +7\. " <<< "$menu_frame"
assert_ok "the window's first stage is drawn" \
    grep -q " 3\. \[" <<< "$menu_frame"
assert_fails "stages above the window are not drawn" \
    grep -q " 1\. \[" <<< "$menu_frame"
assert_fails "stages below the window are not drawn" \
    grep -q " 9\. \[" <<< "$menu_frame"
assert_ok "the list says how many stages are above" \
    grep -q "2 more above" <<< "$menu_frame"
assert_ok "and how many are below" \
    grep -q "2 more below" <<< "$menu_frame"
assert_ok "a finished stage is ticked" \
    grep -q " 3\. \[✓\]" <<< "$menu_frame"
assert_ok "an unplayed stage is not ticked" \
    grep -q " 5\. \[ \]" <<< "$menu_frame"
assert_ok "the stage the player is on is called out" \
    grep -q "4\. .*you are here" <<< "$menu_frame"

# ── Picking a stage without a terminal ─────────────────────
# The tests have no tty, so choose_stage falls back to a typed number.

CURRENT_STAGE=1
CHEAT_CHOICE=""
choose_stage > /dev/null < <(printf '12\n') || true
assert_eq "the chosen stage is remembered" "12" "$CHEAT_CHOICE"

CHEAT_CHOICE=""
assert_fails "a blank answer cancels" choose_stage < <(printf '\n')
assert_eq "cancelling chooses nothing" "" "$CHEAT_CHOICE"

CHEAT_CHOICE=""
assert_fails "a stage that does not exist is refused" choose_stage < <(printf '99\n')

# ── The jump flag ──────────────────────────────────────────

STAGE_JUMP_TARGET=""
assert_fails "no jump is pending by default" jump_requested
STAGE_JUMP_TARGET="7"
assert_ok "a target makes a jump pending" jump_requested
STAGE_JUMP_TARGET=""

# A jump has to bring the skipped stages' commands with it, or the stage it
# lands on refuses half of what its lessons build on.
ALLOWED_COMMANDS=""
assert_fails "grep is locked before anything unlocks it" command_unlocked grep
unlock_prior_commands 7
assert_ok "jumping to stage 7 unlocks stage 2's grep"  command_unlocked grep
assert_ok "jumping to stage 7 unlocks stage 3's chmod" command_unlocked chmod
assert_fails "it does not unlock the stage being jumped to" command_unlocked tar

# ── Repainting ─────────────────────────────────────────────
# Moving the cursor must not redraw the list. Rewriting every row on each
# keypress is what made the menu look like it was reloading.

assert_fails "the frame never clears the screen" \
    grep -q '\[2J' <<< "$(draw_cheat_menu 6 2 5 1 2 3 4 5 6 7 8 9)"
assert_ok "every row erases what the last frame left on it" \
    grep -q '\[K' <<< "$(draw_cheat_menu 6 2 5 1 2 3 4 5 6 7 8 9)"

# The repaint writes to rows by number, so it has to know where the list
# starts. Drawing a frame is what works that out.
MENU_LIST_ROW=0
draw_cheat_menu 6 2 5 1 2 3 4 5 6 7 8 9 > /dev/null
assert_ok "drawing a frame finds the list's first row" \
    test "$MENU_LIST_ROW" -gt 1

# Down one, within the window: only the row left behind and the row arrived
# at get rewritten.
MENU_TOTAL=9 MENU_VISIBLE=5 MENU_FIRST=2 MENU_PREV_FIRST=2 MENU_SELECTED=4
repaint="$(repaint_menu_rows 3 1 2 3 4 5 6 7 8 9)"

assert_ok "the row the cursor left is addressed by number" \
    grep -q "\[$((MENU_LIST_ROW + 3 - MENU_FIRST));1H" <<< "$repaint"
assert_ok "so is the row it arrived on" \
    grep -q "\[$((MENU_LIST_ROW + MENU_SELECTED - MENU_FIRST));1H" <<< "$repaint"

assert_eq "a move rewrites two rows and no more" \
    "2" "$(grep -c '\. \[' <<< "$repaint")"
assert_fails "and does not redraw the header" \
    grep -q "CHEAT CODE" <<< "$repaint"
assert_ok "the row left behind loses the cursor" \
    grep -qE "^[^>]* 4\. \[" <<< "$repaint"
assert_ok "the row arrived at gains it" \
    grep -qE -- "-> +5\. \[" <<< "$repaint"

# A scroll moves every row, so there the whole frame is drawn again.
MENU_FIRST=3 MENU_PREV_FIRST=2 MENU_SELECTED=7
scrolled="$(repaint_menu_rows 6 1 2 3 4 5 6 7 8 9)"
assert_ok "a scroll redraws the frame" grep -q "CHEAT CODE" <<< "$scrolled"

# ── Leaving from a quiz ────────────────────────────────────
# The interview questions have their own prompt, not the shell one, so
# cheatcode has to be handled there separately — and has to leave before the
# question is marked answered.

CURRENT_STAGE=11
COMPLETED_LESSONS=""
COMPLETED_STAGES=""
STAGE_JUMP_TARGET=""
ask_question "01_kernel_vs_shell" > /dev/null < <(printf 'cheatcode\n13\n\n')

assert_eq "cheatcode at a quiz prompt sets the jump" "13" "$STAGE_JUMP_TARGET"
assert_eq "and the question is not marked answered" "" "$COMPLETED_LESSONS"
STAGE_JUMP_TARGET=""

# ── Replaying a finished stage ─────────────────────────────
# Every lesson of a completed stage is marked done, so run_stage would skip
# straight through it. clear_stage_progress is what makes a replay possible.

CURRENT_STAGE=3
COMPLETED_STAGES="1 2 3"
COMPLETED_LESSONS="stage2:01_head stage3:01_ls_l stage3:02_whoami"
COMPLETED_MISSIONS="stage2:skim_mission stage3:audit_mission"
STAGE_1_COMPLETED=true
COMMANDS_PRACTICED="stale junk"

assert_ok "a finished stage reports as finished" stage_is_complete 3
clear_stage_progress 3

assert_fails "a cleared stage is no longer finished" stage_is_complete 3
assert_eq "its lessons are forgotten"  "stage2:01_head"       "$COMPLETED_LESSONS"
assert_eq "its missions are forgotten" "stage2:skim_mission"  "$COMPLETED_MISSIONS"
assert_eq "other stages are untouched" "1 2"                  "$COMPLETED_STAGES"
assert_eq "learned commands drop what the replay must re-earn" \
    "head" "$(get_learned_commands)"

clear_stage_progress 1
assert_eq "clearing stage 1 clears its own flag too" "false" "$STAGE_1_COMPLETED"

finish "Cheat code tests"
