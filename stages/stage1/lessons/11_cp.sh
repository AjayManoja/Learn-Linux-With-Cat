#!/usr/bin/env bash
# Lesson: cp

LESSON_COMMAND="cp"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Don't want to lose your work? Let's make a copy!
The 'cp' command copies a file from a source to a destination.
'cp source_file new_file'. The original file stays right where it is."

TASK_INSTRUCTION="Copy 'notes.txt' to 'notes_backup.txt'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Perfect copy! You can use 'ls' to verify that both files exist now."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="I don't see 'notes_backup.txt' matching 'notes.txt'."
TASK_FAIL_POSE="confused"

HINT_1="Use the copy command followed by the original file, then the new file name."
HINT_2="It starts with cp."
HINT_3="Type 'cp notes.txt notes_backup.txt' and press Enter."

check_task() {
    if check_file_copied "notes.txt" "notes_backup.txt"; then
        return 0
    fi
    return 1
}
