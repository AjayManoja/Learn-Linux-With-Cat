#!/usr/bin/env bash
# Lesson: running a script

LESSON_COMMAND="./script.sh"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Your script has a shebang but no execute bit, so the system
will refuse to run it. You fixed exactly this in Stage 3: chmod +x.
Then you run it by giving its path: './hello.sh' — the './' means
'the one right here', because the shell won't search the current
directory on its own.
Add a line for it to print first, then make it runnable, then run it."

TASK_INSTRUCTION="Append an echo line to scripts/hello.sh, make it executable, and run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="You wrote a program and ran it. Everything after this is just more of it."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="The script needs a command in it, the execute bit, and then to be run."
TASK_FAIL_POSE="confused"

HINT_1="Three steps: add a line, add the bit, run it."
HINT_2="echo ... >> the file, then chmod +x it, then ./ it."
HINT_3="Run: echo 'echo meow' >> scripts/hello.sh / chmod +x scripts/hello.sh / cd scripts then ./hello.sh"

check_task() {
    local f="${SANDBOX_HOME}/scripts/hello.sh"
    [[ -x "$f" ]] \
        && [[ "$(wc -l < "$f")" -ge 2 ]] \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +)(scripts/)?hello\.sh ]]
}
