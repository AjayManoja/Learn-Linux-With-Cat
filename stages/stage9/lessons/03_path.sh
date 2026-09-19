#!/usr/bin/env bash
# Lesson: PATH

LESSON_COMMAND="PATH"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="When you type ls, how does the shell know where ls lives?
It looks in PATH, a list of directories separated by colons.
  echo \$PATH
It tries each one in order and runs the first match. That is the whole
mechanism, and it explains why ./script.sh needs the dot-slash: the
current directory is deliberately not in PATH, so a stray file called ls
cannot hijack the real one."

TASK_INSTRUCTION="Print your PATH."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Every one of those directories is searched, in that order, for every command you type."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Echo the PATH variable, and remember the dollar sign."
TASK_FAIL_POSE="confused"

HINT_1="You know how to print a variable from Stage 5."
HINT_2="The variable is PATH, and reading it needs a dollar sign."
HINT_3="Type: echo \$PATH"

check_task() {
    check_command_matches '^echo +.*\$PATH'
}
