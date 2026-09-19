#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Something Is Still Running"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I left three jobs running and I can't remember what they were. 😾
They're all still going. Find them with 'ps' and stop every one.
Nothing of mine should be left running when you're done."
MISSION_SUCCESS_MSG="All quiet. You found them, identified them, and shut them down."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="First see what's running, then stop them one at a time."
HINT_2="'ps' shows the PIDs. 'kill <PID>' stops one."
HINT_3="Run 'ps', then 'kill <PID>' for each sleep you see. Repeat until ps shows none."

setup_mission() {
    # Three real background processes for the player to hunt down.
    local i
    for i in 1 2 3; do
        ( sleep 600 ) >/dev/null 2>&1 &
        record_game_pid $!
    done
}

check_mission() {
    check_no_background_running
}
