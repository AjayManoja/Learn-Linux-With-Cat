#!/usr/bin/env bash
set -euo pipefail

# Global variables for hints
HINT_LEVEL=1
HINT_1=""
HINT_2=""
HINT_3=""

set_hints() {
    HINT_1="${1:-}"
    HINT_2="${2:-}"
    HINT_3="${3:-}"
}

reset_hint_level() {
    HINT_LEVEL=1
}

get_hint_level() {
    echo "$HINT_LEVEL"
}

give_hint() {
    local hint_text=""
    case $HINT_LEVEL in
        1)
            hint_text="${HINT_1:-No hints available for this task.}"
            ;;
        2)
            hint_text="${HINT_2:-No further hints available.}"
            ;;
        3|*)
            hint_text="${HINT_3:-No further hints available.}"
            ;;
    esac

    # Use UI function if available, else echo
    if command -v show_cat >/dev/null; then
        show_cat "hint" "$hint_text"
    else
        echo "[HINT] $hint_text"
    fi

    # Increment hint level up to 3
    if [[ $HINT_LEVEL -lt 3 ]]; then
        HINT_LEVEL=$((HINT_LEVEL + 1))
    fi

    if command -v increment_hints_used >/dev/null; then
        increment_hints_used
    fi
}
