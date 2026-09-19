#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Account for the Memory"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Three numbers, from the kernel rather than from a guess.
Write memory.txt containing:
  1. the total physical memory
  2. how much is cached
  3. how much is genuinely available
All three are lines in /proc/meminfo. Capture them, do not retype them."
MISSION_SUCCESS_MSG="Total, cached and available. Those three explain almost every 'the server is out of memory' report you will ever receive."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="All three are lines in one file. You want a search that matches several patterns."
HINT_2="grep -E with the three names, redirected into memory.txt."
HINT_3="Run: grep -E 'MemTotal|MemAvailable|^Cached' /proc/meminfo > memory.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/memory.txt"
}

check_mission() {
    check_file_exists "memory.txt" \
        && check_file_matches "memory.txt" 'MemTotal' \
        && check_file_matches "memory.txt" 'Cached' \
        && check_file_matches "memory.txt" 'MemAvailable'
}
