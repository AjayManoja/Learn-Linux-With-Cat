#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="A Script With Your Name On It"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Write me a proper little tool. 🛠️
Create scripts/welcome.sh that:
  1. starts with a shebang line
  2. takes a name as its first argument
  3. prints a greeting using that argument
Make it executable, then run it with a name after it."
MISSION_SUCCESS_MSG="Shebang, argument, execute bit. That is a command you invented."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Everything here you did in the last four lessons, in one file."
HINT_2="Shebang first, then an echo that mentions \$1. chmod +x, then run it with a word after it."
HINT_3="echo '#!/usr/bin/env bash' > scripts/welcome.sh / echo 'echo Welcome \$1' >> scripts/welcome.sh / chmod +x scripts/welcome.sh / bash scripts/welcome.sh Ajay"

setup_mission() {
    mkdir -p "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/welcome.sh"
}

check_mission() {
    local f="${SANDBOX_HOME}/scripts/welcome.sh"
    [[ -f "$f" ]] \
        && head -1 "$f" | grep -q '^#!' \
        && grep -q '\$1' "$f" \
        && [[ -x "$f" ]] \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?welcome\.sh[[:space:]]+[^[:space:]]+ ]]
}
