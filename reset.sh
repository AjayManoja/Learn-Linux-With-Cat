#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GAME_ROOT

source "$GAME_ROOT/src/ui/colors.sh"
source "$GAME_ROOT/src/ui/cat.sh"
source "$GAME_ROOT/src/world/sandbox.sh"

echo -e "${YELLOW}Warning: This will delete the sandbox and every player's saved progress.${RESET}"
read -p "Are you sure you want to reset? (y/N) " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # The sandbox is not always inside the game directory; see sandbox.sh.
    destroy_sandbox
    rm -rf "$GAME_ROOT/sandbox"
    # .catgame holds the per-player saves; .catgame_progress is the single
    # save older versions wrote, still there if that player never came back.
    rm -rf "$GAME_ROOT/.catgame"
    rm -f "$GAME_ROOT/.catgame_progress"
    rm -f "$GAME_ROOT/.mission_code"
    show_cat "sad" "Goodbye, adventurer. Come back soon! 🐾"
    echo -e "${GREEN}Game reset successfully.${RESET}"
else
    show_cat "happy" "Phew! Let's keep playing!"
    echo "Reset cancelled."
fi
