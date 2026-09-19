#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Don't Read It All"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I need to know how big my logs are without reading them. 📏
Count the lines in logs/archive.log, then check how it starts and ends.
Do all three — measure it, peek at the top, peek at the bottom."
MISSION_SUCCESS_MSG="Measured, skimmed, understood. You never opened the whole thing!"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Three commands from this section: one counts, two peek."
HINT_2="wc -l measures. head shows the start. tail shows the end."
HINT_3="Run in turn: wc -l logs/archive.log / head logs/archive.log / tail logs/archive.log"

# Tracks which of the three the player has done. interactive_prompt calls
# check_mission after every command, so progress accumulates here.
SKIM_COUNTED=false
SKIM_HEADED=false
SKIM_TAILED=false

setup_mission() {
    SKIM_COUNTED=false
    SKIM_HEADED=false
    SKIM_TAILED=false
}

check_mission() {
    local last="${LAST_COMMAND:-}"
    [[ "$last" =~ ^wc\ +-l\ +.*archive\.log ]]   && SKIM_COUNTED=true
    [[ "$last" =~ ^head( +-n?[0-9 ]*)?\ +.*archive\.log ]] && SKIM_HEADED=true
    [[ "$last" =~ ^tail( +-n?[0-9 ]*)?\ +.*archive\.log ]] && SKIM_TAILED=true

    [[ "$SKIM_COUNTED" == true && "$SKIM_HEADED" == true && "$SKIM_TAILED" == true ]]
}
