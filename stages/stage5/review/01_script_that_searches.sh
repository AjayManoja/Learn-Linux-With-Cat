#!/usr/bin/env bash
# Review: grep (S2) + redirection (S4) + script (S5)

TASK_INSTRUCTION="Write scripts/errors.sh that searches logs/app.log for ERROR and saves the matches to errors.txt. Run it."
TASK_CAT_POSE="thinking"
RECALLS="Stage 2 — grep · Stage 4 — > · Stage 5 — scripts"

TASK_SUCCESS_MSG="A search, a redirect and a script — three stages working as one tool."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="errors.txt must contain the ERROR lines, and scripts/errors.sh must be what produced it."
TASK_FAIL_POSE="confused"

HINT_1="The command is one you know from Stage 2. The new part is putting it in a file."
HINT_2="Inside the script: grep ERROR logs/app.log > errors.txt"
HINT_3="echo '#!/usr/bin/env bash' > scripts/errors.sh / echo 'grep ERROR logs/app.log > errors.txt' >> scripts/errors.sh / chmod +x scripts/errors.sh / bash scripts/errors.sh"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/logs"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/errors.sh" "${SANDBOX_HOME}/errors.txt"
    {
        echo "[INFO] cat woke up"
        echo "[ERROR] food bowl empty"
        echo "[INFO] sunbeam located"
        echo "[ERROR] door closed unexpectedly"
        echo "[INFO] nap commenced"
    } > "${SANDBOX_HOME}/logs/app.log"
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/errors.sh"
    [[ -f "$f" ]] \
        && grep -q 'grep' "$f" \
        && check_file_exists "errors.txt" \
        && check_file_matches "errors.txt" 'food bowl empty' \
        && ! check_file_matches "errors.txt" 'sunbeam'
}
