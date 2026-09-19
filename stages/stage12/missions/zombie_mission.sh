#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Whose Fault Is This Zombie?"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="There is a zombie on this system and I want it explained,
not killed.
  1. Find the zombie - look for state Z
  2. Work out which process is its parent
  3. Write your diagnosis to diagnosis.txt
Your diagnosis must say who is to blame - the parent - and name the thing
the parent failed to do. The word you want is in the last lesson."
MISSION_SUCCESS_MSG="Correct. The zombie is a symptom; the parent that never reaped it is the bug. Killing the zombie achieves nothing."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="ps shows you the Z. The PPID column shows you who is responsible."
HINT_2="Your diagnosis needs to blame the parent and mention reaping or wait()."
HINT_3="Run: python3 demos/zombie_demo.py &  then ps -o pid,ppid,stat,comm  then write your answer into diagnosis.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/diagnosis.txt"
}

check_mission() {
    check_file_exists "diagnosis.txt" \
        && check_file_matches "diagnosis.txt" '[Pp]arent' \
        && check_file_matches "diagnosis.txt" '[Rr]eap|wait|[Ee]xit status'
}
