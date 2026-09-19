#!/usr/bin/env bash
# Lesson: tail

LESSON_COMMAND="tail"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="If 'head' shows the beginning, 'tail' shows the end.
This matters more than it sounds: log files grow downward, so the newest
events are always at the bottom. When something breaks, 'tail' is where
you look first."

TASK_INSTRUCTION="Look at the end of logs/system.log with 'tail'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The newest entries, straight away. That's how you read a log."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Try 'tail' on logs/system.log."
TASK_FAIL_POSE="confused"

HINT_1="The opposite of 'head'."
HINT_2="The command is 'tail', and it takes a filename."
HINT_3="Type: tail logs/system.log"

check_task() {
    check_command_matches '^tail( +-n?[0-9]*)*( +-n +[0-9]+)? +(logs/)?system\.log$'
}
