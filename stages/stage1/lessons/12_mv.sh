#!/usr/bin/env bash
# Lesson: mv

LESSON_COMMAND="mv"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Sometimes you want to move a file, or just rename it.
The 'mv' command does both! It moves a file from old to new.
Unlike copy, the original file disappears, and only the new one remains."

TASK_INSTRUCTION="Rename 'cat_food.txt' to 'snacks.txt'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Delicious! 'snacks.txt' is ready. 'ls' will show that 'cat_food.txt' is gone."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Did you use 'mv' to rename the file?"
TASK_FAIL_POSE="confused"

HINT_1="Use the move command, old name first, then new name."
HINT_2="It's just mv."
HINT_3="Type 'mv cat_food.txt snacks.txt' and press Enter."

check_task() {
    if check_file_moved "cat_food.txt" "snacks.txt"; then
        return 0
    fi
    return 1
}
