#!/usr/bin/env bash
# Lesson: exec in practice

LESSON_COMMAND="exec"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="fork gave you a second copy. exec is what makes it useful.
exec loads a different program into the process and jumps to it. The PID
stays the same — same process, new contents. Anything after the exec call
never runs, because there is nothing left to run it.
This is why Stage 9's PATH mattered: exec needs a real filename, so the
shell searches PATH first to turn 'ls' into '/usr/bin/ls'."

TASK_INSTRUCTION="Run demos/exec_demo.py and watch a process become a different program."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Same PID, different program, and the line after exec never ran. There was no process left to run it."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run it with: python3 demos/exec_demo.py"
TASK_FAIL_POSE="confused"

HINT_1="Another demo in the same directory."
HINT_2="Run exec_demo.py with python3."
HINT_3="Type: python3 demos/exec_demo.py"

check_task() {
    check_command_matches '^python3? +.*exec_demo\.py'
}
