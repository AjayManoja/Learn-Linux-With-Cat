#!/usr/bin/env bash
# Lesson: exit codes

LESSON_COMMAND="echo \$?"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Every command leaves a number behind when it finishes.
Zero means it worked. Anything else means it did not.
  ls notes.txt
  echo \$?
That \$? holds the exit code of the last command. Run something that
fails and it will be non-zero.
This number is what the next four lessons are built on: it is how one
command decides whether the next should run."

TASK_INSTRUCTION="Run any command, then print its exit code with: echo \$?"
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Zero for success. Every decision the shell makes about success rests on that number."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Print the special variable that holds the last exit code."
TASK_FAIL_POSE="confused"

HINT_1="The shell keeps the result of the last command in a variable."
HINT_2="Its name is a question mark, read with a dollar sign."
HINT_3="Type: echo \$?"

check_task() {
    check_command_matches '^echo +.*\$\?'
}
