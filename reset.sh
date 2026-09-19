#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GAME_ROOT

source "$GAME_ROOT/src/ui/colors.sh"
source "$GAME_ROOT/src/ui/cat.sh"
source "$GAME_ROOT/src/world/sandbox.sh"

echo -e "${YELLOW}Warning: This will delete all progress and the sandbox environment.${RESET}"
read -p "Are you sure you want to reset? (y/N) " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # The sandbox is not always inside the game directory; see sandbox.sh.
    destroy_sandbox
    rm -rf "$GAME_ROOT/sandbox"
    rm -f "$GAME_ROOT/.catgame_progress"
    rm -f "$GAME_ROOT/.mission_code"
    show_cat "sad" "Goodbye, adventurer. Come back soon! 🐾"
    echo -e "${GREEN}Game reset successfully.${RESET}"
else
    show_cat "happy" "Phew! Let's keep playing!"
    echo "Reset cancelled."
fi
