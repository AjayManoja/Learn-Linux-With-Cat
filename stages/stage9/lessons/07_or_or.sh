#!/usr/bin/env bash
# Lesson: ||

LESSON_COMMAND="||"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'||' is the mirror image: run the second command only if the
first FAILED.
  cat missing.txt || echo 'no such file'
It is how scripts report problems without an if block, and the two
together read almost like a sentence:
  command && echo worked || echo failed"

TASK_INSTRUCTION="Try to read a file that does not exist, and print a message if it fails — joined with ||."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The fallback fired because the first command failed. That is error handling in one line."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run something that fails, then || and an echo."
TASK_FAIL_POSE="confused"

HINT_1="You want the second command to run only when the first goes wrong."
HINT_2="The operator is two pipe characters."
HINT_3="Type: cat missing.txt || echo not found"

check_task() {
    check_command_matches '\|\|' && check_command_matches '^(cat|ls|grep) +'
}
