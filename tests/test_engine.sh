#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export GAME_ROOT

source "$GAME_ROOT/src/engine/progress.sh"

echo "Testing engine..."

export PLAYER_NAME="testplayer"
export CURRENT_STAGE="stage1"
export COMPLETED_LESSONS=""
save_progress
if [[ -f "$GAME_ROOT/.catgame_progress" ]]; then
    echo "PASS: Progress saved"
else
    echo "FAIL: Progress not saved"
fi

load_progress
if [[ "$PLAYER_NAME" == "testplayer" ]]; then
    echo "PASS: Progress loaded"
else
    echo "FAIL: Progress load failed"
fi

rm -f "$GAME_ROOT/.catgame_progress"

echo "Engine tests complete."
