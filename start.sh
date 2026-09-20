#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GAME_ROOT

# Source all engine modules
source "$GAME_ROOT/src/ui/colors.sh"
source "$GAME_ROOT/src/ui/cat.sh"
source "$GAME_ROOT/src/ui/box.sh"
source "$GAME_ROOT/src/ui/banner.sh"
source "$GAME_ROOT/src/ui/menu.sh"
source "$GAME_ROOT/src/engine/progress.sh"
# Both after progress.sh: the command history lives beside the player's save,
# and the title screen is those profile operations with a list drawn over them.
source "$GAME_ROOT/src/engine/history.sh"
source "$GAME_ROOT/src/engine/players.sh"
source "$GAME_ROOT/src/engine/hints.sh"
# The command shapes the lessons show under their explanation.
source "$GAME_ROOT/src/engine/formats.sh"
# sandbox.sh first: it decides where the sandbox lives, and safety.sh and
# checker.sh both resolve their paths against that.
source "$GAME_ROOT/src/world/sandbox.sh"
source "$GAME_ROOT/src/engine/safety.sh"
source "$GAME_ROOT/src/engine/checker.sh"
source "$GAME_ROOT/src/engine/runner.sh"
# cheat.sh calls into the runner (stage_exists) and the runner calls back into
# it (jump_requested), so it has to come after.
source "$GAME_ROOT/src/engine/cheat.sh"
source "$GAME_ROOT/src/world/maze.sh"
source "$GAME_ROOT/src/world/filesystem.sh"

# Show welcome
show_welcome_banner

# Line editing on before the first thing the player types: without it an
# arrow key here is four stray characters in their own name.
init_line_editing

# Who is playing: the saves that exist, and the new, rename and delete that
# go with them. Comes back with the name in PLAYER_CHOICE, or exits the game
# if nobody is playing after all.
player_title_screen
PLAYER_NAME="$PLAYER_CHOICE"
export PLAYER_NAME

# Load this player's own save. Each name keeps its own progress: loading
# before the name was known meant whoever played first owned the game, and
# every later player resumed their stage under their own name.
if select_player_profile "$PLAYER_NAME"; then
    returning_player=true
else
    returning_player=false
fi

# From here on the save is written on the way out, whichever way out it is:
# quitting, Ctrl-C, the terminal window closing, or Ubuntu sending everything
# a TERM as it shuts down.
install_save_traps

# Their own history now that their profile is known, so the commands behind
# ↑ are the ones this player typed last time.
init_command_history

# The sandbox is built per stage by run_game, which knows which world each
# stage needs.

# Initialize safety
init_safety

# Start the game
if $returning_player; then
    show_cat "happy" "Welcome back, $PLAYER_NAME! Picking up at Stage ${CURRENT_STAGE}."
else
    show_cat "happy" "Welcome, $PLAYER_NAME! Let's learn Linux together!"
fi
echo ""
echo "Type 'hint' for help, 'progress' to check your status, or 'quit' to save and exit."
echo "Type 'cheatcode' to jump to any stage."
echo ""

run_game "$CURRENT_STAGE"
