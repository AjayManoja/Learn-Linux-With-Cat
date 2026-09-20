#!/usr/bin/env bash
# menu.sh — the pieces every arrow-key list in the game is built from.
#
# Two screens use them: the cheatcode stage picker, and the title screen's
# player list. Both read one keypress at a time, draw onto the alternate
# screen so the game underneath is given back untouched, and repaint a row by
# overwriting it rather than clearing the screen — a screen cleared between
# frames is what makes a list appear to reload every time the cursor moves.

# One keypress, as a word. Arrow keys arrive as an escape sequence, so a bare
# Esc is only known to be bare once nothing follows it — hence the timeout.
#
# A key with no meaning here comes back as itself, so a menu can answer to
# letters of its own ("d" to delete, "r" to rename) without every menu having
# to know how to take a terminal apart. The words it does return — up, down,
# enter, cancel — are all longer than one character, so they cannot collide.
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
        *)       printf '%s' "$key" ;;
    esac
}

# Whether there is a terminal to drive a menu with. Without one — a piped
# session, a dumb TERM — the screens fall back to printing a numbered list
# and reading an answer.
menu_available() {
    [[ -t 0 ]] && [[ -t 1 ]]
}

# The alternate screen keeps the menu from scrolling the game away, and gives
# the session back exactly as it was on the way out. The screen is cleared
# once, here, and never again — see menu_line.
menu_screen_enter() { printf '\e[?1049h\e[?25l\e[H\e[2J'; }
menu_screen_leave() { printf '\e[?25h\e[?1049l'; }

# The row the next menu_line will write. Tracked while drawing so a repaint
# can address a single row directly instead of the whole frame.
MENU_ROW=1

# One line of the menu, overwriting whatever the last frame left on that row.
# Erasing to the end of the line is what replaces clearing the screen.
menu_line() {
    printf '%b\e[K\n' "$1"
    MENU_ROW=$((MENU_ROW + 1))
}

# Put the cursor back at the top left, ready to draw a frame.
menu_home() {
    printf '\e[H'
    MENU_ROW=1
}
