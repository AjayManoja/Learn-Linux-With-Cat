#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Graduation"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Last one. Everything you know, in a single script. 🎓
Write scripts/graduate.sh that:
  1. begins with a shebang
  2. takes a directory name as \$1
  3. uses a for loop over the files in it
  4. uses an if to test each one
  5. writes its findings into graduation.txt
Make it executable and run it against the scripts directory.
When graduation.txt lists what it found, you're done — and so is the game."
MISSION_SUCCESS_MSG="Five stages, one script, and you wrote it yourself. Go and use a real terminal now. 🐟"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Every piece of this was a separate lesson. Now they go in one file."
HINT_2="Shebang, then 'for F in \$1/*; do', then 'if [ -f \"\$F\" ]; then', an echo redirected with >>, then fi and done."
HINT_3="Build it line by line with echo and >>, chmod +x scripts/graduate.sh, then: bash scripts/graduate.sh scripts"

setup_mission() {
    mkdir -p "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/graduation.txt"
}

check_mission() {
    local f="${SANDBOX_HOME}/scripts/graduate.sh"
    [[ -f "$f" ]] \
        && head -1 "$f" | grep -q '^#!' \
        && [[ -x "$f" ]] \
        && grep -q '\$1' "$f" \
        && grep -q '\bfor\b' "$f" && grep -q '\bdone\b' "$f" \
        && grep -q '\bif\b' "$f"  && grep -q '\bfi\b' "$f" \
        && check_file_exists "graduation.txt" \
        && [[ -s "${SANDBOX_HOME}/graduation.txt" ]]
}
