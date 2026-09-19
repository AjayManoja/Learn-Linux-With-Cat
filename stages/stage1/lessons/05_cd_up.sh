#!/usr/bin/env bash
# Lesson: cd ..

LESSON_COMMAND="cd .."
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="To go back or move up one level, we use 'cd ..'
The two dots (..) represent the parent directory.
It's like walking out of the room you are currently in, back into the hallway."

TASK_INSTRUCTION="Go up from Documents using 'cd ..', then confirm with 'pwd'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Excellent! You're back where you started."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Make sure there's a space between 'cd' and '..'"
TASK_FAIL_POSE="confused"

HINT_1="Go to the parent directory."
HINT_2="Use the change directory command with two dots."
HINT_3="Type 'cd ..' and press Enter."

check_task() {
    # Check if they went back up to the home directory
    if check_current_dir "/home/catplayer"; then
        return 0
    fi
    return 1
}
