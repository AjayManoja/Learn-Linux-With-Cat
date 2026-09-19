#!/usr/bin/env bash
# Review: ps (S12) + sort (S4) + head (S2) + pipes (S2)

TASK_INSTRUCTION="Find the three processes using the most memory on this machine, and save that list to top3.txt."
TASK_CAT_POSE="thinking"
RECALLS="Stage 12 - ps -o · Stage 4 - sort · Stage 2 - head, pipes"

TASK_SUCCESS_MSG="A process listing sorted by a column and trimmed to three. That is Stage 4 and Stage 2 doing Stage 12's work."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="top3.txt needs a few lines of ps output, ranked by memory."
TASK_FAIL_POSE="confused"

HINT_1="ps can print a memory column; something else sorts it and something else trims it."
HINT_2="ps -eo pid,rss,comm then sort by the rss column, then head."
HINT_3="Run: ps -eo pid,rss,comm --sort=-rss | head -4 > top3.txt"

setup_challenge() {
    rm -f "${SANDBOX_HOME}/top3.txt"
}

check_task() {
    check_file_exists "top3.txt" \
        && [[ "$(wc -l < "${SANDBOX_HOME}/top3.txt")" -ge 2 ]] \
        && [[ "$(wc -l < "${SANDBOX_HOME}/top3.txt")" -le 10 ]]
}
