#!/usr/bin/env bash
# Lesson: grep

LESSON_COMMAND="grep"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="This is the one. 'grep' searches inside files.
'grep WORD file.txt' prints every line containing WORD and hides the rest.
Instead of reading 400 lines hoping to spot something, you ask for it.
This single command will save you more time than everything else you know."

TASK_INSTRUCTION="Find every ERROR line in logs/system.log with 'grep'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="There they are. You just searched a whole file in one command!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Search for ERROR inside logs/system.log."
TASK_FAIL_POSE="confused"

HINT_1="You want only the lines that mention a problem."
HINT_2="'grep' takes what to look for, then where to look."
HINT_3="Type: grep ERROR logs/system.log"

check_task() {
    check_command_matches '^grep +.*ERROR.* +(logs/)?system\.log$'
}
