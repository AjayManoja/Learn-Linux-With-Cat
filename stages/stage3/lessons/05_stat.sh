#!/usr/bin/env bash
# Lesson: stat

LESSON_COMMAND="stat"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'ls -l' shows permissions as letters. 'stat' shows everything.
Look for the Access line: it gives the same permissions twice, once as
numbers like 0644 and once as letters like -rw-r--r--.
Those numbers are the other way of writing permissions, and the next
lesson is built on them."

TASK_INSTRUCTION="Run 'stat report.txt' and find the Access line."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="0644 and -rw-r--r-- are the same thing said twice. Now you can use either."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Try 'stat' on report.txt."
TASK_FAIL_POSE="confused"

HINT_1="There's a command that prints everything the system knows about a file."
HINT_2="The command is 'stat'."
HINT_3="Type: stat report.txt"

check_task() {
    check_command_matches '^stat +.*report\.txt$'
}
