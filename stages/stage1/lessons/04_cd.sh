#!/usr/bin/env bash
# Lesson: cd

LESSON_COMMAND="cd"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Ready to move? The 'cd' command changes your directory.
It's how you walk from one room (folder) into another.
Just type 'cd' followed by the name of the folder you want to enter."

TASK_INSTRUCTION="Change directory into 'Documents', then confirm your new location with 'pwd'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="You made it! You are now in the Documents folder."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Did you use 'cd Documents'? Check your spelling!"
TASK_FAIL_POSE="confused"

HINT_1="Move into the Documents folder."
HINT_2="Use the change directory command."
HINT_3="Type 'cd Documents' and press Enter, then type 'pwd'."

check_task() {
    if check_current_dir "Documents"; then
        return 0
    fi
    return 1
}
