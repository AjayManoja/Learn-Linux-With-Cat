#!/usr/bin/env bash
# Review: find -exec (S7) + chmod (S3) + tee (S10)

TASK_INSTRUCTION="Every .sh file under bin/ has lost its execute bit. Fix them all in one command, and save the list of what you fixed to fixed.txt while still showing it."
TASK_CAT_POSE="thinking"
RECALLS="Stage 7 — find -exec · Stage 3 — chmod · Stage 10 — tee"

TASK_SUCCESS_MSG="Found, fixed and logged without typing a single filename. Three stages, one line."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="All three .sh files under bin/ need the execute bit, and fixed.txt must list them."
TASK_FAIL_POSE="confused"

HINT_1="First make them executable, then record which ones you touched."
HINT_2="find bin -name \"*.sh\" -exec chmod +x {} \; then list them through tee."
HINT_3="Run: find bin -name \"*.sh\" -exec chmod +x {} \;   then: find bin -name \"*.sh\" | tee fixed.txt"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/bin"
    rm -f "${SANDBOX_HOME}/fixed.txt"
    local n
    for n in start stop status; do
        echo "#!/usr/bin/env bash" > "${SANDBOX_HOME}/bin/${n}.sh"
        chmod 644 "${SANDBOX_HOME}/bin/${n}.sh" 2>/dev/null || true
    done
}

check_task() {
    check_file_executable "bin/start.sh" \
        && check_file_executable "bin/stop.sh" \
        && check_file_executable "bin/status.sh" \
        && check_file_exists "fixed.txt" \
        && check_file_matches "fixed.txt" 'start\.sh'
}
