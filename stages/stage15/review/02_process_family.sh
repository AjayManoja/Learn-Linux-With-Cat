#!/usr/bin/env bash
# Review: /proc (S11) + grep (S2) + cut/awk (S6)

TASK_INSTRUCTION="Extract just the PPid line from your own process's status file, and save it to parent.txt."
TASK_CAT_POSE="thinking"
RECALLS="Stage 11 - /proc/self · Stage 2 - grep · Stage 4 - >"

TASK_SUCCESS_MSG="The kernel's own record, filtered to the one line you wanted. /proc is just files, so every text tool you know works on it."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="parent.txt should contain the PPid line from /proc/self/status."
TASK_FAIL_POSE="confused"

HINT_1="It is a file, so search it the way you search any file."
HINT_2="grep PPid out of /proc/self/status and redirect it."
HINT_3="Run: grep PPid /proc/self/status > parent.txt"

setup_challenge() {
    rm -f "${SANDBOX_HOME}/parent.txt"
}

check_task() {
    check_file_exists "parent.txt" && check_file_matches "parent.txt" 'PPid'
}
