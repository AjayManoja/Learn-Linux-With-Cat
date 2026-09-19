#!/usr/bin/env bash
# Lesson: rm

LESSON_COMMAND="rm"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="warning"

LESSON_CONTENT="Be careful with this one! 'rm' removes (deletes) files permanently.
There's no default undo, so double-check before you press Enter!
(To delete folders, you'd need 'rm -r', but let's just stick to files for now.)"

TASK_INSTRUCTION="Delete 'junk.txt'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Gone! Don't worry, I saved a backup in my trash bin... just in case."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="The file 'junk.txt' is still here. Try again."
TASK_FAIL_POSE="confused"

HINT_1="Use the remove command on the file."
HINT_2="It's simply rm."
HINT_3="Type 'rm junk.txt' and press Enter."

check_task() {
    if check_file_missing "junk.txt"; then
        return 0
    fi
    return 1
}
