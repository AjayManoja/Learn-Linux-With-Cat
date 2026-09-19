#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GAME_ROOT

source "$GAME_ROOT/src/ui/colors.sh"
source "$GAME_ROOT/src/ui/cat.sh"
source "$GAME_ROOT/src/engine/progress.sh"

if [[ $# -ne 1 ]]; then
    echo "Usage: ./check.sh <CODE>"
    exit 1
fi

provided_code="$1"
code_file="$GAME_ROOT/.mission_code"

if [[ -f "$code_file" ]]; then
    actual_code=$(cat "$code_file")
    if [[ "$provided_code" == "$actual_code" ]]; then
        show_cat "celebrate" "You found the correct code! Mission accomplished! 🏆"
        load_progress
        mark_stage_complete "$CURRENT_STAGE"
        echo ""
        echo "Stage $CURRENT_STAGE complete! Your progress has been saved."
    else
        show_cat "confused" "That doesn't seem to be the right code... Try again!"
    fi
else
    show_cat "confused" "No active mission code found. Complete the mission first!"
fi

