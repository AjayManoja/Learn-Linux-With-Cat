#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GAME_ROOT

# Source all engine modules
source "$GAME_ROOT/src/ui/colors.sh"
source "$GAME_ROOT/src/ui/cat.sh"
source "$GAME_ROOT/src/ui/box.sh"
source "$GAME_ROOT/src/ui/banner.sh"
source "$GAME_ROOT/src/engine/progress.sh"
source "$GAME_ROOT/src/engine/hints.sh"
source "$GAME_ROOT/src/engine/safety.sh"
source "$GAME_ROOT/src/engine/checker.sh"
source "$GAME_ROOT/src/engine/runner.sh"
source "$GAME_ROOT/src/world/sandbox.sh"
source "$GAME_ROOT/src/world/maze.sh"
source "$GAME_ROOT/src/world/filesystem.sh"

# Show welcome
show_welcome_banner

# Ask for player name
echo ""
read -p "🐱 What's your name, adventurer? [catplayer]: " player_input
PLAYER_NAME="${player_input:-catplayer}"
export PLAYER_NAME

# Load or create progress
load_progress

# The sandbox is built per stage by run_game, which knows which world each
# stage needs.

# Initialize safety
init_safety

# Start the game
show_cat "happy" "Welcome, $PLAYER_NAME! Let's learn Linux together!"
echo ""
echo "Type 'hint' for help, 'progress' to check your status, or 'quit' to save and exit."
echo ""

run_game "$CURRENT_STAGE"
