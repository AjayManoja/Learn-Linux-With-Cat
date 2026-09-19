#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Navigation Mastery"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Cat has lost a note somewhere in the filesystem. Player must navigate using only learned commands (pwd, ls, ls -la, cd) to find and identify it."
MISSION_SUCCESS_MSG="You found the missing note! Excellent navigation skills!"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Use 'ls -la' to look for hidden directories or files."
HINT_2="Try checking the 'secret_garden' directory."
HINT_3="Look for a file named '.hidden_note' and identify its path."

setup_mission() {
    build_nav_maze
}

check_mission() {
    check_file_exists "$GAME_ROOT/sandbox/home/catplayer/secret_garden/.hidden_note"
}
