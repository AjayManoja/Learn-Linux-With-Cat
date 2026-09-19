#!/usr/bin/env bash
# Review: /proc/meminfo (S15) + grep -E (S2) + tee (S10)

TASK_INSTRUCTION="Capture MemTotal, MemFree and MemAvailable to snapshot.txt while also showing them on screen."
TASK_CAT_POSE="thinking"
RECALLS="Stage 15 - /proc/meminfo · Stage 2 - grep -E · Stage 10 - tee"

TASK_SUCCESS_MSG="Seen and saved in one pass. The Stage 10 habit applied to Stage 15's data."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="snapshot.txt needs all three Mem lines, and a plain redirect would have hidden them from you."
TASK_FAIL_POSE="confused"

HINT_1="Three patterns from one file, and something that both prints and saves."
HINT_2="grep -E with all three names, piped into tee."
HINT_3="Run: grep -E 'MemTotal|MemFree|MemAvailable' /proc/meminfo | tee snapshot.txt"

setup_challenge() {
    rm -f "${SANDBOX_HOME}/snapshot.txt"
}

check_task() {
    check_file_exists "snapshot.txt" \
        && check_file_matches "snapshot.txt" 'MemTotal' \
        && check_file_matches "snapshot.txt" 'MemFree' \
        && check_file_matches "snapshot.txt" 'MemAvailable'
}
