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

# Placeholders; setup_mission rewrites these once the maze is built.
HINT_1="Check all the hidden directories."
HINT_2="Follow the clues from one directory to the next."
HINT_3="The fish toy file is called 'fish.txt'."

setup_mission() {
    build_hidden_cat_maze

    set_hints \
        "Nothing here shows up with a plain 'ls'. Use 'ls -la' everywhere you go." \
        "The clues chain together — each clue.txt names where to look next. Read them with 'cat'." \
        "The fish is in ${HIDDEN_FISH_DIR}. Try: cd ${HIDDEN_FISH_DIR} then cat fish.txt"
}

check_mission() {
    # setup_mission writes .mission_code itself, so testing for that file marked
    # the mission complete before the player had moved. Require them to actually
    # stand where the fish is instead.
    check_current_dir "${HIDDEN_FISH_DIR}" && check_file_exists "${HIDDEN_FISH_DIR}/fish.txt"
}
