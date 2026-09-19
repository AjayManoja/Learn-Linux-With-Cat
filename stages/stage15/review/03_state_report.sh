#!/usr/bin/env bash
# Review: ps states (S12) + awk (S6) + sort|uniq -c (S4)

TASK_INSTRUCTION="Count how many processes are in each state on this machine, and save the tally to states.txt."
TASK_CAT_POSE="thinking"
RECALLS="Stage 12 - process states · Stage 6 - awk · Stage 4 - sort, uniq -c"

TASK_SUCCESS_MSG="A state histogram of a live machine, built from three commands you already had. Mostly S, as it should be."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="states.txt needs counts of state letters - extract the state column, then count it."
TASK_FAIL_POSE="confused"

HINT_1="Get every process's state as one column, then count repeated values."
HINT_2="ps -eo stat piped into sort and uniq -c."
HINT_3="Run: ps -eo stat --no-headers | sort | uniq -c > states.txt"

setup_challenge() {
    rm -f "${SANDBOX_HOME}/states.txt"
}

check_task() {
    check_file_exists "states.txt" \
        && check_file_matches "states.txt" '[0-9]+ +[A-Za-z]'
}
