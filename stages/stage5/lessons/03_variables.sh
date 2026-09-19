#!/usr/bin/env bash
# Lesson: variables

LESSON_COMMAND="NAME=value"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A variable stores a value under a name:
  NAME=\"cat\"
  echo \"\$NAME\"
Two rules catch everyone out. No spaces around the '=' when you set it,
and a '\$' in front of the name when you read it.
Set it without the dollar, use it with the dollar."

TASK_INSTRUCTION="Set a variable and print it: NAME=\"cat\" then echo \"\$NAME\" — do it inside scripts/whoami.sh and run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The script remembered a value and used it. That's a variable."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="scripts/whoami.sh should set a variable and echo it, then be run."
TASK_FAIL_POSE="confused"

HINT_1="Build the file line by line with echo and >>, same as before."
HINT_2="Line 1 the shebang, line 2 sets a variable, line 3 echoes it with a dollar sign."
HINT_3="echo '#!/usr/bin/env bash' > scripts/whoami.sh / echo 'NAME=cat' >> scripts/whoami.sh / echo 'echo \$NAME' >> scripts/whoami.sh / chmod +x scripts/whoami.sh / bash scripts/whoami.sh"

check_task() {
    local f="${SANDBOX_HOME}/scripts/whoami.sh"
    [[ -f "$f" ]] \
        && grep -qE '^[A-Za-z_][A-Za-z0-9_]*=' "$f" \
        && grep -q '\$' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?whoami\.sh ]]
}
