#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Last Mission"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Ten stages. One script. 🎓
Write scripts/report.sh that, when run:
  - starts with a shebang and set -euo pipefail
  - finds every .log file under logs/
  - counts the ERROR lines across them
  - writes a summary line into report.txt naming that count
  - exits 0
Then run it. Everything you need has been taught. Nothing is new."
MISSION_SUCCESS_MSG="Ten stages of commands, assembled into one tool that you wrote. There is nothing left for me to teach you. Go and use a real terminal. 🐟"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Every piece was its own lesson. This is only the assembly."
HINT_2="grep -c ERROR across the logs, captured with \$( ), echoed into report.txt."
HINT_3="Inside the script: echo \"errors: \$(grep -h ERROR logs/*.log | wc -l)\" > report.txt"

setup_mission() {
    ensure_sandbox_dir "${SANDBOX_HOME}/logs"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/report.sh" "${SANDBOX_HOME}/report.txt"
    printf '[INFO] up\n[ERROR] bowl empty\n[INFO] nap\n'      > "${SANDBOX_HOME}/logs/app.log"
    printf '[ERROR] door shut\n[ERROR] no sunbeam\n[INFO] ok\n' > "${SANDBOX_HOME}/logs/db.log"
}

check_mission() {
    local f="${SANDBOX_HOME}/scripts/report.sh"
    [[ -f "$f" ]] \
        && head -1 "$f" | grep -q '^#!' \
        && grep -qE '^ *set +-[euo]' "$f" \
        && check_file_exists "report.txt" \
        && check_file_matches "report.txt" '3'
}
