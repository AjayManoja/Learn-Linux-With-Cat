#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Both Stuck"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Diagnose the deadlock and prescribe the fix.
Write deadlock_fix.txt explaining:
  - why the two threads are stuck
  - the one-word change that prevents it
You have run both the broken version and the fixed one. The difference
between them is a single idea."
MISSION_SUCCESS_MSG="Circular wait, broken by a consistent lock order. That is the answer interviewers want, and now you have watched both halves of it."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Each thread holds one lock and wants the other. What is that shape called?"
HINT_2="Mention circular wait, and the fix: a lock order."
HINT_3="Write: deadlock from circular wait - each holds one lock and waits for the other. Fix: always acquire locks in the same order."

setup_mission() {
    rm -f "${SANDBOX_HOME}/deadlock_fix.txt"
}

check_mission() {
    check_file_exists "deadlock_fix.txt" \
        && check_file_matches "deadlock_fix.txt" '[Cc]ircular|[Ww]ait.*each other|each other' \
        && check_file_matches "deadlock_fix.txt" '[Oo]rder'
}
