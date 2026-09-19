#!/usr/bin/env bash
# Lesson: find

LESSON_COMMAND="find"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'grep' searches inside files. 'find' searches for files.
That's the difference, and it's worth remembering.
'find .' lists everything beneath where you're standing — the dot means
'here'. It's how you see the shape of a directory tree at a glance."

TASK_INSTRUCTION="List everything below your home directory with 'find .'"
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That's your whole world in one listing."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Try 'find' with a dot for the current directory."
TASK_FAIL_POSE="confused"

HINT_1="You want to see every file below where you are."
HINT_2="'find' takes a starting point. A dot means 'right here'."
HINT_3="Type: find ."

check_task() {
    check_command_matches '^find +\.?/?$'
}
