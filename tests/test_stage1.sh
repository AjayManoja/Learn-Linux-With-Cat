#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$GAME_ROOT/src/world/sandbox.sh"
# source "$GAME_ROOT/stages/stage1/stage.conf"

echo "Testing Stage 1..."

create_sandbox "stage1"
if [[ -d "$GAME_ROOT/sandbox/home/catplayer" ]]; then
    echo "PASS: Sandbox created"
else
    echo "FAIL: Sandbox creation failed"
fi

rm -rf "$GAME_ROOT/sandbox"

echo "Stage 1 tests complete."
