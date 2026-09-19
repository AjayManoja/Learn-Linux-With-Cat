#!/usr/bin/env bash
# Lesson: mkdir

LESSON_COMMAND="mkdir"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Let's build something! 'mkdir' stands for Make Directory.
It creates a brand new, empty folder.
Just type 'mkdir' followed by the name of the folder you want."

TASK_INSTRUCTION="Create a folder called 'mission'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Awesome! Use 'ls' to verify it was created."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Did you use 'mkdir mission'?"
TASK_FAIL_POSE="confused"

HINT_1="Use the make directory command."
HINT_2="The folder should be exactly named 'mission'."
HINT_3="Type 'mkdir mission' and press Enter."

check_task() {
    if check_dir_exists "mission"; then
        return 0
    fi
    return 1
}
