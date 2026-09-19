#!/usr/bin/env bash
# Lesson: script arguments

LESSON_COMMAND="\$1"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A script that always does the same thing is a note.
A script that takes input is a tool.
Inside a script, \$1 is the first thing typed after its name, \$2 the second.
  ./greet.sh Ajay
makes \$1 equal to Ajay. That's how every command you've used this whole
game receives its arguments — including the ones you ran today."

TASK_INSTRUCTION="Make scripts/greet.sh echo a greeting using \$1, then run it with your name after it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Your script takes input now. It's a real command."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="scripts/greet.sh should use \$1, and you need to run it WITH an argument."
TASK_FAIL_POSE="confused"

HINT_1="The script needs to mention \$1, and you must pass something when running it."
HINT_2="Write 'echo hello \$1' into the script, then run it followed by a word."
HINT_3="echo '#!/usr/bin/env bash' > scripts/greet.sh / echo 'echo hello \$1' >> scripts/greet.sh / chmod +x scripts/greet.sh / bash scripts/greet.sh Ajay"

check_task() {
    local f="${SANDBOX_HOME}/scripts/greet.sh"
    [[ -f "$f" ]] \
        && grep -q '\$1' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?greet\.sh[[:space:]]+[^[:space:]]+ ]]
}
