#!/usr/bin/env bash
# Lesson: set -e

LESSON_COMMAND="set -euo pipefail"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="By default a script carries on after a command fails, which
means a broken step can be followed by nineteen more that assume it worked.
  set -e            stop at the first failure
  set -u            stop if an unset variable is used
  set -o pipefail   a pipeline fails if any part of it fails
Together, on line two of every script you write:
  set -euo pipefail
Every script in this game starts with it. Now you know why."

TASK_INSTRUCTION="Write scripts/strict.sh with a shebang and set -euo pipefail, then run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That one line turns silent wrongness into a loud stop. It is the single best habit in shell scripting."
TASK_SUCCESS_POSE="celebrate"

TASK_FAIL_MSG="scripts/strict.sh needs a shebang and a set -e line, and you need to run it."
TASK_FAIL_POSE="confused"

HINT_1="Two lines before anything else: the shebang, then the safety line."
HINT_2="The second line is: set -euo pipefail"
HINT_3="echo '#!/usr/bin/env bash' > scripts/strict.sh / echo 'set -euo pipefail' >> scripts/strict.sh / echo 'echo strict' >> scripts/strict.sh / bash scripts/strict.sh"

setup_lesson() {
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/strict.sh"
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/strict.sh"
    [[ -f "$f" ]] \
        && head -1 "$f" | grep -q '^#!' \
        && grep -qE '^ *set +-[euo]' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?strict\.sh ]]
}
