#!/usr/bin/env bash
# Lesson: nl

LESSON_COMMAND="nl"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'nl' numbers the lines of a file.
That sounds trivial until you are reading someone an error report over
the phone, or comparing two versions of a list. 'grep -n' numbers only the
lines that matched; 'nl' numbers all of them."

TASK_INSTRUCTION="Number the lines of data/memo.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Now every line has an address you can refer to."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run nl on data/memo.txt."
TASK_FAIL_POSE="confused"

HINT_1="Two letters, short for 'number lines'."
HINT_2="The command is nl, and it takes a filename."
HINT_3="Type: nl data/memo.txt"

check_task() {
    check_command_matches '^nl +.*memo\.txt$'
}
