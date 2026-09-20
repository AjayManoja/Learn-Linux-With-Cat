#!/usr/bin/env bash
set -euo pipefail

# cheat.sh — the `cheatcode` command: an arrow-key stage picker.
#
# Stages are meant to be played in order, and fifteen of them is a long way to
# walk to reach the one you are working on. Typing `cheatcode` at any prompt
# opens a list of every stage, moves through it with the arrow keys, and drops
# the player into whichever one they pick. The stages in between are skipped,
# not faked: nothing is marked complete that was not played.
#
# The jump itself cannot happen here — this runs several calls deep, inside a
# lesson, inside a section, inside the stage runner. Instead the target is left
# in STAGE_JUMP_TARGET and every one of those loops unwinds on it. See
# jump_requested and run_game.

# The stage to jump to, set by the picker and cleared by run_game.
STAGE_JUMP_TARGET="${STAGE_JUMP_TARGET:-}"

# Where the picker leaves its answer. It cannot be printed on stdout: the menu
# is drawn there, and a caller capturing the result would swallow the drawing.
CHEAT_CHOICE=""

jump_requested() {
    [[ -n "${STAGE_JUMP_TARGET:-}" ]]
}

# ── Stage list ─────────────────────────────────────────────

# A stage's name, read out of its config rather than sourced: sourcing a
# stage.conf here would overwrite the SECTION_* variables of the stage the
# player is standing in.
stage_title() {
    local conf="${GAME_ROOT}/stages/stage${1}/stage.conf" line
    [[ -f "$conf" ]] || return 1
    line="$(grep -m1 '^STAGE_NAME=' "$conf")" || return 1
    line="${line#STAGE_NAME=}"
    line="${line%\"}"
    line="${line#\"}"
    printf '%s' "$line"
}

# Every stage that exists, in order. Stages are contiguous from 1, so the
# first gap is the end of the game.
list_stage_numbers() {
    local n=1
    while stage_exists "$n"; do
        printf '%s\n' "$n"
        n=$((n + 1))
    done
}

# ── Key input ──────────────────────────────────────────────

# One keypress, as a word. Arrow keys arrive as an escape sequence, so a bare
# Esc is only known to be bare once nothing follows it — hence the timeout.
read_menu_key() {
    local key rest=""

    IFS= read -rsn1 key || { printf 'cancel'; return 0; }

    case "$key" in
        '')
            # read -n1 strips the newline, so Enter arrives as nothing at all.
            printf 'enter'
            ;;
        $'\e')
            IFS= read -rsn2 -t 0.05 rest || rest=""
            case "$rest" in
                '[A') printf 'up' ;;
                '[B') printf 'down' ;;
                '')   printf 'cancel' ;;
                *)    printf 'other' ;;
            esac
            ;;
        k|K|w|W) printf 'up' ;;
        j|J|s|S) printf 'down' ;;
        q|Q)     printf 'cancel' ;;
        *)       printf 'other' ;;
    esac
}

# ── Menu drawing ───────────────────────────────────────────

# The alternate screen keeps the menu from scrolling the game away, and gives
# the session back exactly as it was on the way out. The screen is cleared
# once, here, and never again — see menu_line.
cheat_menu_enter() { printf '\e[?1049h\e[?25l\e[H\e[2J'; }
cheat_menu_leave() { printf '\e[?25h\e[?1049l'; }

# The row the cursor is about to write, and the row the stage list starts on.
# Tracked while drawing so the repaint can address a single row directly,
# instead of the whole frame.
MENU_ROW=1
MENU_LIST_ROW=1

# One line of the menu, overwriting whatever the last frame left on that row.
# Erasing to the end of the line is what replaces clearing the screen: a
# cleared screen between frames is exactly what made the list appear to
# reload every time the cursor moved.
menu_line() {
    printf '%b\e[K\n' "$1"
    MENU_ROW=$((MENU_ROW + 1))
}

# How many stages fit on screen, leaving room for the header and footer.
cheat_menu_capacity() {
    local rows
    rows="$(tput lines 2>/dev/null || echo 24)"
    [[ "$rows" =~ ^[0-9]+$ ]] || rows=24

    local capacity=$((rows - 9))
    ((capacity < 3)) && capacity=3
    printf '%s' "$capacity"
}

# One row as text: cursor, number, completion mark, name. Returned rather
# than printed, so the same row can go into a full frame or a single-row
# repaint.
stage_row_text() {
    local stage_num="$1" selected="$2"
    local cursor="  " mark=" " suffix="" name label
    name="$(stage_title "$stage_num" || true)"
    # Right-aligned so 9 and 10 line up now that the game has fifteen stages.
    label="$(printf '%2s' "$stage_num")"

    if stage_is_complete "$stage_num"; then
        mark="✓"
    fi
    if [[ "$stage_num" == "${CURRENT_STAGE:-}" ]]; then
        suffix="   <- you are here"
    fi

    if [[ "$selected" == "yes" ]]; then
        printf '%s' "${GREEN}${BOLD}-> ${label}. [${mark}] ${name}${suffix}${RESET}"
    elif [[ "$mark" == "✓" ]]; then
        printf '%s' "${DIM}${cursor} ${label}. [${mark}] ${name}${suffix}${RESET}"
    else
        printf '%s' "${cursor} ${label}. [${mark}] ${name}${suffix}"
    fi
}

# The whole frame. Drawn once when the menu opens, and again only when the
# list scrolls; an ordinary move up or down repaints two rows instead.
draw_cheat_menu() {
    local selected_index="$1" first="$2" visible="$3"
    shift 3
    local stages=("$@")
    local total="${#stages[@]}"
    local i

    printf '\e[H'
    MENU_ROW=1

    menu_line "${MAGENTA}${BOLD}"
    menu_line "$(draw_dashed_line 52)"
    menu_line "  CHEAT CODE - jump straight to any stage"
    menu_line "$(draw_dashed_line 52)"
    menu_line "${RESET}${DIM}  up/down move    enter jump    q cancel${RESET}"
    menu_line ""

    if ((first > 0)); then
        menu_line "${DIM}      ... ${first} more above${RESET}"
    else
        menu_line ""
    fi

    # Recorded rather than hardcoded, so a change to the header above cannot
    # silently send the repaint to the wrong row.
    MENU_LIST_ROW="$MENU_ROW"

    for ((i = first; i < first + visible && i < total; i++)); do
        if ((i == selected_index)); then
            menu_line "$(stage_row_text "${stages[i]}" "yes")"
        else
            menu_line "$(stage_row_text "${stages[i]}" "no")"
        fi
    done

    local below=$((total - first - visible))
    if ((below > 0)); then
        menu_line "${DIM}      ... ${below} more below${RESET}"
    else
        menu_line ""
    fi

    menu_line ""
    menu_line "$(draw_dashed_line 52)"
}

# ── Cursor movement ────────────────────────────────────────

# Where the cursor is and which slice of the list is on screen. Kept out here
# rather than inside the key loop so the movement rules can be exercised
# without a terminal to drive.
MENU_SELECTED=0
MENU_FIRST=0
MENU_TOTAL=0
MENU_VISIBLE=0
# Where the window was before the last move, so the repaint can tell an
# ordinary move from one that scrolled the list.
MENU_PREV_FIRST=0

# Applies one key. Returns 0 to keep the menu open, 1 once the player has
# either chosen (enter) or backed out (cancel).
cheat_menu_move() {
    case "$1" in
        up)   ((MENU_SELECTED > 0)) && MENU_SELECTED=$((MENU_SELECTED - 1)) ;;
        down) ((MENU_SELECTED < MENU_TOTAL - 1)) && MENU_SELECTED=$((MENU_SELECTED + 1)) ;;
        enter|cancel) return 1 ;;
    esac

    # The list scrolls only when the cursor would otherwise leave the window.
    ((MENU_SELECTED < MENU_FIRST)) && MENU_FIRST="$MENU_SELECTED"
    ((MENU_SELECTED >= MENU_FIRST + MENU_VISIBLE)) \
        && MENU_FIRST=$((MENU_SELECTED - MENU_VISIBLE + 1))

    return 0
}

# Puts the cursor's move on screen. Only the row it left and the row it
# arrived on are rewritten, so the rest of the menu is never touched and the
# list does not blink. A scroll is the one case that moves every row, and
# only then is the whole frame drawn again.
repaint_menu_rows() {
    local previous="$1"
    shift
    local stages=("$@")

    if ((MENU_FIRST != MENU_PREV_FIRST)); then
        draw_cheat_menu "$MENU_SELECTED" "$MENU_FIRST" "$MENU_VISIBLE" "${stages[@]}"
        return 0
    fi

    printf '\e[%d;1H' "$((MENU_LIST_ROW + previous - MENU_FIRST))"
    menu_line "$(stage_row_text "${stages[previous]}" "no")"

    printf '\e[%d;1H' "$((MENU_LIST_ROW + MENU_SELECTED - MENU_FIRST))"
    menu_line "$(stage_row_text "${stages[MENU_SELECTED]}" "yes")"
}

# ── The picker ─────────────────────────────────────────────

# Numbered list and a typed answer, for when there is no terminal to drive —
# a piped session, or a dumb TERM.
choose_stage_by_number() {
    local stages=("$@") stage_num answer mark

    echo ""
    echo -e "${BOLD}CHEAT CODE - jump straight to any stage${RESET}"
    draw_dashed_line 52
    for stage_num in "${stages[@]}"; do
        mark=" "
        stage_is_complete "$stage_num" && mark="✓"
        printf '  %2s. [%s] %s\n' "$stage_num" "$mark" "$(stage_title "$stage_num" || true)"
    done
    draw_dashed_line 52

    read -r -p "Stage number (blank to cancel): " answer || answer=""
    answer="${answer//[[:space:]]/}"

    [[ -n "$answer" ]] || return 1
    if [[ ! "$answer" =~ ^[0-9]+$ ]] || ! stage_exists "$answer"; then
        show_cat "confused" "There is no Stage ${answer}."
        return 1
    fi

    CHEAT_CHOICE="$answer"
}

# Leaves the chosen stage number in CHEAT_CHOICE, or returns 1 if the player
# backed out.
choose_stage() {
    local stages=()
    mapfile -t stages < <(list_stage_numbers)

    CHEAT_CHOICE=""
    ((${#stages[@]} > 0)) || return 1

    if [[ ! -t 0 || ! -t 1 ]]; then
        choose_stage_by_number "${stages[@]}"
        return
    fi

    MENU_TOTAL="${#stages[@]}"
    MENU_VISIBLE="$(cheat_menu_capacity)"
    ((MENU_VISIBLE > MENU_TOTAL)) && MENU_VISIBLE="$MENU_TOTAL"

    # Open on the stage the player is actually in.
    local i
    MENU_SELECTED=0
    for ((i = 0; i < MENU_TOTAL; i++)); do
        [[ "${stages[i]}" == "${CURRENT_STAGE:-1}" ]] && MENU_SELECTED="$i"
    done

    MENU_FIRST=0
    ((MENU_SELECTED >= MENU_VISIBLE)) && MENU_FIRST=$((MENU_SELECTED - MENU_VISIBLE + 1))

    cheat_menu_enter
    # Ctrl-C here must not leave the terminal on the alternate screen with no
    # cursor — the player would be typing blind into what looks like the menu.
    trap 'cheat_menu_leave; exit 130' INT

    draw_cheat_menu "$MENU_SELECTED" "$MENU_FIRST" "$MENU_VISIBLE" "${stages[@]}"

    local key="" previous
    while true; do
        key="$(read_menu_key)"

        previous="$MENU_SELECTED"
        MENU_PREV_FIRST="$MENU_FIRST"
        cheat_menu_move "$key" || break

        # A key that changed nothing — up at the top, or an unbound key —
        # redraws nothing at all.
        if ((previous != MENU_SELECTED || MENU_FIRST != MENU_PREV_FIRST)); then
            repaint_menu_rows "$previous" "${stages[@]}"
        fi
    done

    trap - INT
    cheat_menu_leave

    [[ "$key" == "enter" ]] || return 1
    CHEAT_CHOICE="${stages[MENU_SELECTED]}"
}

# ── Entry point ────────────────────────────────────────────

# Called from interactive_prompt. Sets STAGE_JUMP_TARGET if the player picks a
# stage; the loops above interactive_prompt do the rest.
cheat_code_menu() {
    if ! choose_stage; then
        echo ""
        show_cat "thinking" "Staying put. Back to it!"
        echo ""
        return 0
    fi

    local target="$CHEAT_CHOICE"

    if [[ "$target" == "${CURRENT_STAGE:-}" ]]; then
        echo ""
        show_cat "happy" "You are already on Stage ${target}. Carry on!"
        echo ""
        return 0
    fi

    # A finished stage has every lesson marked done, so jumping into it would
    # skip straight through to the next one. Offer to wipe its record.
    if stage_is_complete "$target"; then
        local answer=""
        echo ""
        show_cat "thinking" "Stage ${target} is already finished: $(stage_title "$target" || true)"
        read -r -p "Play it again from the first lesson? (y/N) " answer || answer=""
        if [[ ! "$answer" =~ ^[Yy]$ ]]; then
            echo ""
            show_cat "thinking" "Staying put. Back to it!"
            echo ""
            return 0
        fi
        clear_stage_progress "$target"
    fi

    STAGE_JUMP_TARGET="$target"

    echo ""
    show_cat "celebrate" "Cheat code accepted! Warping to Stage ${target}: $(stage_title "$target" || true)"
    echo -e "${DIM}The sandbox is rebuilt for that stage, and every command from"
    echo -e "the stages you skipped is unlocked so nothing is out of reach.${RESET}"
    echo ""
    read -r -p "Press Enter to go... " || true
    echo ""
}
