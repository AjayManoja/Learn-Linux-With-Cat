#!/usr/bin/env bash
# Review: sort | uniq -c (S4) + $1 (S5) + pipes (S2)

TASK_INSTRUCTION="Write scripts/tally.sh that takes a filename as \$1 and prints a count of each repeated line in it. Run it on data/visitors.txt."
TASK_CAT_POSE="thinking"
RECALLS="Stage 4 — sort, uniq -c · Stage 2 — pipes · Stage 5 — \$1"

TASK_SUCCESS_MSG="A general-purpose counting tool that works on any file you hand it. That is the difference an argument makes."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="The script must use \$1, and you must run it with data/visitors.txt after it."
TASK_FAIL_POSE="confused"

HINT_1="The counting pipeline is from Stage 4. The argument is from Stage 5."
HINT_2="Inside the script: sort \$1 | uniq -c"
HINT_3="echo 'sort \$1 | uniq -c' >> scripts/tally.sh, chmod +x it, then: bash scripts/tally.sh data/visitors.txt"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/data"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/tally.sh"
    {
        echo "bird"; echo "mouse"; echo "bird"; echo "fox"
        echo "bird"; echo "mouse"; echo "squirrel"
    } > "${SANDBOX_HOME}/data/visitors.txt"
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/tally.sh"
    [[ -f "$f" ]] \
        && grep -q '\$1' "$f" \
        && grep -q 'uniq' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?tally\.sh[[:space:]]+.*visitors\.txt ]]
}
