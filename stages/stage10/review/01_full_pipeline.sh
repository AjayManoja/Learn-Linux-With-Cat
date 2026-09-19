#!/usr/bin/env bash
# Review: grep (S2) + cut (S6) + sort/uniq (S4) + redirect (S4)

TASK_INSTRUCTION="access.log lines look like 'DATE user action'. Count how many actions each user performed and save the tally to busiest.txt."
TASK_CAT_POSE="thinking"
RECALLS="Stage 6 — cut/awk · Stage 4 — sort, uniq -c · Stage 4 — >"

TASK_SUCCESS_MSG="A field extracted, counted and stored. Stages 4 and 6 have not faded."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="busiest.txt needs a count per user — pull out the user column, then count it."
TASK_FAIL_POSE="confused"

HINT_1="The user is the second field. Extract it, then count repeats."
HINT_2="awk '{print \$2}' or cut -d' ' -f2, then sort | uniq -c."
HINT_3="Run: awk '{print \$2}' access.log | sort | uniq -c > busiest.txt"

setup_challenge() {
    rm -f "${SANDBOX_HOME}/busiest.txt"
    {
        echo "2024-03-15 mochi opened"
        echo "2024-03-15 pepper closed"
        echo "2024-03-15 mochi slept"
        echo "2024-03-15 mochi ate"
        echo "2024-03-15 pepper slept"
    } > "${SANDBOX_HOME}/access.log"
}

check_task() {
    check_file_exists "busiest.txt" \
        && check_file_matches "busiest.txt" '3 +mochi' \
        && check_file_matches "busiest.txt" '2 +pepper'
}
