#!/usr/bin/env bash
set -euo pipefail

# players.sh — the title screen: who is playing, and everything you can do to
# that list.
#
# The game used to print the names that had a save and ask you to type one.
# That was the whole of it: a name typed differently was a new player, a
# profile could not be renamed, and the only way to be rid of one was to know
# where the game keeps its saves and delete the file by hand. This is the
# same list with the rest of the verbs attached — play, new, rename, delete —
# drawn over the profile operations in progress.sh.
#
# It is drawn with the pieces in src/ui/menu.sh, the same ones the cheatcode
# stage picker uses. With no terminal to drive (a piped session, a dumb TERM)
# the list is printed with numbers and read as a line, so every operation is
# still reachable.

# Where the screen leaves its answer. Neither can be printed on stdout: the
# menu is drawn there.
PLAYER_CHOICE=""
PLAYER_ACTION=""
# Set when a typed command carried the new name with it: "rename 2 Ada".
PLAYER_RENAME_TO=""

# The marker standing in for the "new adventurer" row at the foot of the
# list. No real name can collide with it: sanitize_player_name drops control
# characters.
PLAYER_NEW_ROW=$'\001new\001'

# Where the list starts on screen, and which slice of it is showing.
PLAYER_LIST_ROW=1
PLAYER_SELECTED=0
PLAYER_FIRST=0
PLAYER_VISIBLE=0
PLAYER_TOTAL=0

# ── Drawing ────────────────────────────────────────────────

player_menu_capacity() {
    local rows
    rows="$(tput lines 2>/dev/null || echo 24)"
    [[ "$rows" =~ ^[0-9]+$ ]] || rows=24

    local capacity=$((rows - 11))
    ((capacity < 3)) && capacity=3
    printf '%s' "$capacity"
}

# One row: the cursor, the name, and how far that player got. The last row of
# the list is not a player at all but the way to make one; it is drawn here
# too so the cursor behaves the same on every row.
player_row_text() {
    local name="$1" selected="$2" body

    if [[ "$name" == "$PLAYER_NEW_ROW" ]]; then
        body="$(printf '%-22s %s' "+ new adventurer" "start a fresh save")"
    else
        body="$(printf '%-22s %s' "🐾 ${name}" "$(player_profile_summary "$name" || true)")"
    fi

    if [[ "$selected" == "yes" ]]; then
        printf '%s' "${GREEN}${BOLD}-> ${body}${RESET}"
    else
        printf '%s' "   ${body}"
    fi
}

draw_player_menu() {
    local rows=("$@")
    local total="${#rows[@]}"
    local i

    menu_home

    menu_line "${MAGENTA}${BOLD}"
    menu_line "$(draw_dashed_line 60)"
    menu_line "  WHO IS PLAYING?"
    menu_line "$(draw_dashed_line 60)"
    menu_line "${RESET}${DIM}  up/down move   enter play   n new   r rename   d delete   q quit${RESET}"
    menu_line ""

    if ((PLAYER_FIRST > 0)); then
        menu_line "${DIM}      ... ${PLAYER_FIRST} more above${RESET}"
    else
        menu_line ""
    fi

    PLAYER_LIST_ROW="$MENU_ROW"

    for ((i = PLAYER_FIRST; i < PLAYER_FIRST + PLAYER_VISIBLE && i < total; i++)); do
        if ((i == PLAYER_SELECTED)); then
            menu_line "$(player_row_text "${rows[i]}" "yes")"
        else
            menu_line "$(player_row_text "${rows[i]}" "no")"
        fi
    done

    local below=$((total - PLAYER_FIRST - PLAYER_VISIBLE))
    if ((below > 0)); then
        menu_line "${DIM}      ... ${below} more below${RESET}"
    else
        menu_line ""
    fi

    menu_line ""
    menu_line "$(draw_dashed_line 60)"
    # A deleted player would otherwise leave a row behind: this frame is one
    # line shorter than the last, and the old final row is still on screen.
    printf '\e[J'
}

# ── Cursor movement ────────────────────────────────────────

# Applies one key. Returns 0 to keep the menu open, 1 once the screen has
# been answered — PLAYER_ACTION says what it was answered with.
player_menu_key() {
    case "$1" in
        up)   ((PLAYER_SELECTED > 0)) && PLAYER_SELECTED=$((PLAYER_SELECTED - 1)) ;;
        down) ((PLAYER_SELECTED < PLAYER_TOTAL - 1)) && PLAYER_SELECTED=$((PLAYER_SELECTED + 1)) ;;
        enter)  PLAYER_ACTION="play";   return 1 ;;
        n|N)    PLAYER_ACTION="new";    return 1 ;;
        r|R)    PLAYER_ACTION="rename"; return 1 ;;
        d|D)    PLAYER_ACTION="delete"; return 1 ;;
        cancel) PLAYER_ACTION="quit";   return 1 ;;
    esac

    # The list scrolls only when the cursor would otherwise leave the window.
    ((PLAYER_SELECTED < PLAYER_FIRST)) && PLAYER_FIRST="$PLAYER_SELECTED"
    ((PLAYER_SELECTED >= PLAYER_FIRST + PLAYER_VISIBLE)) \
        && PLAYER_FIRST=$((PLAYER_SELECTED - PLAYER_VISIBLE + 1))

    return 0
}

# ── The picker ─────────────────────────────────────────────

# Arrow-key list. Sets PLAYER_ACTION, and PLAYER_CHOICE when the action is
# about one of the players.
choose_player_from_menu() {
    local names=("$@")
    local rows=("${names[@]}" "$PLAYER_NEW_ROW")

    PLAYER_TOTAL="${#rows[@]}"
    PLAYER_VISIBLE="$(player_menu_capacity)"
    ((PLAYER_VISIBLE > PLAYER_TOTAL)) && PLAYER_VISIBLE="$PLAYER_TOTAL"
    ((PLAYER_SELECTED >= PLAYER_TOTAL)) && PLAYER_SELECTED=$((PLAYER_TOTAL - 1))
    ((PLAYER_SELECTED < 0)) && PLAYER_SELECTED=0
    PLAYER_FIRST=0
    ((PLAYER_SELECTED >= PLAYER_VISIBLE)) && PLAYER_FIRST=$((PLAYER_SELECTED - PLAYER_VISIBLE + 1))

    PLAYER_ACTION=""
    PLAYER_CHOICE=""

    menu_screen_enter
    # Ctrl-C here must not leave the terminal on the alternate screen with no
    # cursor: the player would be typing blind into what looks like a menu.
    trap 'menu_screen_leave; exit 130' INT

    while true; do
        draw_player_menu "${rows[@]}"
        player_menu_key "$(read_menu_key)" || break
    done

    trap - INT
    menu_screen_leave

    local picked="${rows[PLAYER_SELECTED]}"
    if [[ "$picked" == "$PLAYER_NEW_ROW" ]]; then
        # Enter on that row means the same as pressing n, and rename or
        # delete have nothing there to work on.
        case "$PLAYER_ACTION" in
            play|rename|delete) PLAYER_ACTION="new" ;;
        esac
        return 0
    fi

    PLAYER_CHOICE="$picked"
    return 0
}

# The same choices, typed. This is what a piped session gets, and it keeps
# the old behaviour of the title screen: a name on its own still plays.
choose_player_by_typing() {
    local names=("$@")
    local answer="" index

    echo ""
    echo -e "${BOLD}Adventurers with a save here:${RESET}"
    for ((index = 0; index < ${#names[@]}; index++)); do
        printf '  %2s. 🐾 %-22s %s\n' \
            "$((index + 1))" "${names[index]}" \
            "$(player_profile_summary "${names[index]}" || true)"
    done
    echo ""
    echo -e "${DIM}A number plays that save; any other name starts or resumes one.${RESET}"
    echo -e "${DIM}Also: 'rename <number> <new name>', 'delete <number>', 'quit'.${RESET}"

    PLAYER_ACTION=""
    PLAYER_CHOICE=""
    PLAYER_RENAME_TO=""

    if ! read_line "> " answer; then
        # End of input: nobody is there to ask, so play the most recent save
        # rather than sitting on a prompt no one will answer.
        PLAYER_ACTION="play"
        PLAYER_CHOICE="${names[0]}"
        return 0
    fi

    answer="${answer#"${answer%%[![:space:]]*}"}"
    answer="${answer%"${answer##*[![:space:]]}"}"

    local verb="${answer%% *}" rest=""
    [[ "$answer" == *" "* ]] && rest="${answer#* }"

    case "$verb" in
        quit|exit)
            PLAYER_ACTION="quit"
            return 0
            ;;
        rename|delete)
            local number="${rest%% *}"
            if ! PLAYER_CHOICE="$(player_at_number "$number" "${names[@]}")"; then
                show_cat "confused" "There is no player ${number:-?} in that list."
                PLAYER_ACTION=""
                return 0
            fi
            PLAYER_ACTION="$verb"
            # "rename 2 Ada" carries the new name with it; ask_rename_player
            # uses it when it is there and asks when it is not.
            if [[ "$verb" == "rename" && "$rest" == *" "* ]]; then
                PLAYER_RENAME_TO="${rest#* }"
            fi
            return 0
            ;;
    esac

    if [[ "$answer" =~ ^[0-9]+$ ]]; then
        if ! PLAYER_CHOICE="$(player_at_number "$answer" "${names[@]}")"; then
            show_cat "confused" "There is no player ${answer} in that list."
            PLAYER_ACTION=""
            return 0
        fi
        PLAYER_ACTION="play"
        return 0
    fi

    PLAYER_CHOICE="$(sanitize_player_name "${answer:-catplayer}")"
    [[ -n "$PLAYER_CHOICE" ]] || PLAYER_CHOICE="catplayer"
    PLAYER_ACTION="play"
    return 0
}

# The name at a 1-based position in the list, or nothing if there is no such
# position.
player_at_number() {
    local number="$1"
    shift
    local names=("$@")

    [[ "$number" =~ ^[0-9]+$ ]] || return 1
    ((number >= 1 && number <= ${#names[@]})) || return 1
    printf '%s' "${names[number - 1]}"
}

# ── The operations ─────────────────────────────────────────

# Create: ask for a name. A name that already has a save is not an error —
# it is the player coming back, which is how this screen has always worked.
ask_new_player() {
    local name=""

    echo ""
    read_line "🐱 What's your name, adventurer? [catplayer]: " name || name=""
    name="$(sanitize_player_name "$name")"
    [[ -n "$name" ]] || name="catplayer"

    if player_profile_exists "$name"; then
        show_cat "happy" "\"${name}\" already has a save here — opening it."
    fi

    PLAYER_CHOICE="$name"
    return 0
}

# Update: the profile, its save file and its command history move together.
ask_rename_player() {
    local old="$1" new="${PLAYER_RENAME_TO:-}" status=0
    PLAYER_RENAME_TO=""

    echo ""
    if [[ -z "$new" ]]; then
        read_line "New name for \"${old}\" (blank to cancel): " new || new=""
    fi
    new="$(sanitize_player_name "$new")"

    if [[ -z "$new" ]]; then
        show_cat "thinking" "Left as \"${old}\"."
        return 0
    fi

    rename_player_profile "$old" "$new" || status=$?
    case "$status" in
        0) show_cat "happy" "\"${old}\" is now \"${new}\"." ;;
        1) show_cat "confused" "\"${new}\" already has a save of its own." ;;
        *) show_cat "confused" "That name cannot be used." ;;
    esac
    return 0
}

# Delete: the save and the history, behind a confirmation, because there is
# no undo for either.
ask_delete_player() {
    local name="$1" answer=""

    echo ""
    show_cat "warning" "Deleting \"${name}\" erases their stage, their finished lessons and their command history. There is no undo."
    read_line "Delete \"${name}\"? (y/N) " answer || answer=""

    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        show_cat "happy" "Kept. Nothing was deleted."
        return 0
    fi

    if delete_player_profile "$name"; then
        show_cat "sad" "\"${name}\" is gone. 🐾"
    else
        show_cat "confused" "\"${name}\" could not be deleted."
    fi
    return 0
}

# ── The screen ─────────────────────────────────────────────

# Runs until somebody is chosen, and leaves the name in PLAYER_CHOICE.
# Quitting from here exits the game: this is the one screen where quitting
# means not playing at all.
player_title_screen() {
    local names=()

    while true; do
        mapfile -t names < <(list_player_profiles)

        # Nobody has played here yet, so there is no list to manage.
        if ((${#names[@]} == 0)); then
            ask_new_player
            return 0
        fi

        if menu_available; then
            choose_player_from_menu "${names[@]}"
        else
            choose_player_by_typing "${names[@]}"
        fi

        case "$PLAYER_ACTION" in
            play)   [[ -n "$PLAYER_CHOICE" ]] && return 0 ;;
            new)    ask_new_player; return 0 ;;
            rename) ask_rename_player "$PLAYER_CHOICE" ;;
            delete) ask_delete_player "$PLAYER_CHOICE" ;;
            quit)
                echo ""
                show_cat "sad" "Nobody playing today? See you soon! 🐾"
                exit 0
                ;;
        esac
    done
}
