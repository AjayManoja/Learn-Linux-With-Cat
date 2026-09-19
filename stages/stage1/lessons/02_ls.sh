#!/usr/bin/env bash
# Lesson: ls

LESSON_COMMAND="ls"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Now that we know where we are, what's around us?
The 'ls' command lists all files and folders in your current directory.
It's like looking around the room to see what objects are there."

TASK_INSTRUCTION="Run 'ls' to see what files are here."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Great! You can see everything around you now. Always remember you can use 'pwd' to confirm where you are looking!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Not quite. We want to list the files."
TASK_FAIL_POSE="confused"

HINT_1="We need a command that lists things."
HINT_2="It's a two-letter command starting with l."
HINT_3="Type 'ls' and press Enter."

check_task() {
    check_command_matches '^ls$'
}
