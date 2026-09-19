#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="A Tool, Not a Script"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Write me something I would trust to run unattended. 🛠️
scripts/deploy.sh must:
  1. start with a shebang and set -euo pipefail
  2. refuse to run with no argument, printing a usage line and exiting 1
  3. otherwise create a directory named after the argument
Run it once with no argument, then once with the argument 'release'."
MISSION_SUCCESS_MSG="It refuses bad input, stops on failure, and does its job. That is a tool."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Three parts: the safety line, the argument check, the actual work."
HINT_2="set -euo pipefail, then if [ -z \"\$1\" ]; then echo usage; exit 1; fi, then mkdir \$1"
HINT_3="Build those lines with echo and >>, then run it with no argument and again with: bash scripts/deploy.sh release"

setup_mission() {
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/deploy.sh"
    rm -rf "${SANDBOX_HOME}/release"
}

check_mission() {
    local f="${SANDBOX_HOME}/scripts/deploy.sh"
    [[ -f "$f" ]] \
        && head -1 "$f" | grep -q '^#!' \
        && grep -qE '^ *set +-[euo]' "$f" \
        && grep -q '\-z' "$f" \
        && grep -qE 'exit +1' "$f" \
        && check_dir_exists "release"
}
