#!/usr/bin/env bash
# Review: find (S7) + cut/awk (S6) + sort|uniq -c (S4)

TASK_INSTRUCTION="library/catalogue.txt lists items as 'title:genre'. Count how many there are of each genre and save the tally to genres.txt."
TASK_CAT_POSE="thinking"
RECALLS="Stage 6 — cut · Stage 4 — sort, uniq -c · Stage 4 — >"

TASK_SUCCESS_MSG="Extracted a column, counted the repeats, saved the result. Stages 4 and 6 doing one job."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="genres.txt needs a count for each genre — extract the field, then count it."
TASK_FAIL_POSE="confused"

HINT_1="Pull out the genre column first, then count repeated lines."
HINT_2="cut -d: -f2 gets the genre; sort | uniq -c counts them."
HINT_3="Run: cut -d: -f2 library/catalogue.txt | sort | uniq -c > genres.txt"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/library"
    rm -f "${SANDBOX_HOME}/genres.txt"
    {
        echo "The Long Nap:sleep"
        echo "Boxes I Have Known:memoir"
        echo "Advanced Sunbeams:sleep"
        echo "The Red Dot:thriller"
        echo "Further Boxes:memoir"
        echo "Sleeping Upside Down:sleep"
    } > "${SANDBOX_HOME}/library/catalogue.txt"
}

check_task() {
    check_file_exists "genres.txt" \
        && check_file_matches "genres.txt" '3 +sleep' \
        && check_file_matches "genres.txt" '2 +memoir'
}
