#!/usr/bin/env bash
# Review: everything

TASK_INSTRUCTION="Write scripts/audit.sh that takes a directory as \$1, refuses to run without one, counts the .txt files in it, and writes the count into audit_result.txt. Run it on papers."
TASK_CAT_POSE="thinking"
RECALLS="Stage 5 — scripts, \$1, if · Stage 9 — \$( ), exit · Stage 7 — find · Stage 4 — >"

TASK_SUCCESS_MSG="An argument, a guard, a search, a substitution and a redirect — five stages in one file. That is the whole game."
TASK_SUCCESS_POSE="celebrate"
TASK_FAIL_MSG="The script needs a -z check on \$1, and running it on papers must produce audit_result.txt with the count."
TASK_FAIL_POSE="confused"

HINT_1="Guard the argument first, then do the work with it."
HINT_2="if [ -z \"\$1\" ]; then exit 1; fi, then count with find and \$( )."
HINT_3="Body: if [ -z \"\$1\" ]; then exit 1; fi  /  echo \$(find \$1 -name \"*.txt\" | wc -l) > audit_result.txt"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/papers"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/audit.sh" "${SANDBOX_HOME}/audit_result.txt"
    local i
    for i in 1 2 3 4 5; do
        echo "paper ${i}" > "${SANDBOX_HOME}/papers/p${i}.txt"
    done
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/audit.sh"
    [[ -f "$f" ]] \
        && grep -q '\-z' "$f" \
        && grep -q '\$1' "$f" \
        && check_file_exists "audit_result.txt" \
        && check_file_matches "audit_result.txt" '5'
}
