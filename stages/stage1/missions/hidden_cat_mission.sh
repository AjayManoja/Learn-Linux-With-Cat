#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Hidden Fish Toy"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Oh no! My favourite fish toy is missing! 🐟
Someone hid it somewhere in your filesystem.
Find it using only commands you've learned.
There might be clues hidden in unexpected places...
When you find the fish, it contains a secret code.
Run: ./check.sh <CODE> to complete the mission!"
MISSION_SUCCESS_MSG="You found my fish toy! Thank you so much!"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Check all the hidden directories."
HINT_2="There might be a clue in the .config directory."
HINT_3="The fish toy file is called 'fish.txt'."

setup_mission() {
    build_hidden_cat_maze
}

check_mission() {
    local code_file="$GAME_ROOT/.mission_code"
    if [[ -f "$code_file" ]]; then
        return 0
    else
        return 1
    fi
}
