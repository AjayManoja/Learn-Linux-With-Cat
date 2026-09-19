#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Who Came Through The Cat Flap?"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Something got in last night. 🐾
logs/system.log has 400 lines and I am not reading them.
Two of those lines are marked ERROR and they tell the whole story:
who came in, and the lock code they used.
Search the log, find both, and read the lock code line."
MISSION_SUCCESS_MSG="An intruder, identified from 400 lines, without reading 398 of them. That's Stage 2."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="You don't need to read the log. You need to search it."
HINT_2="Try: grep ERROR logs/system.log"
HINT_3="Run: grep -n ERROR logs/system.log — both lines you want are in the output."

INTRUDER_FOUND=false

setup_mission() {
    INTRUDER_FOUND=false
}

check_mission() {
    # The ERROR lines are planted by populate_stage_files. Requiring a grep that
    # actually targets them is what proves the player searched rather than
    # scrolled.
    if [[ "${LAST_COMMAND:-}" =~ ^grep\ +.*ERROR.*system\.log ]]; then
        INTRUDER_FOUND=true
    fi
    [[ "$INTRUDER_FOUND" == true ]]
}
