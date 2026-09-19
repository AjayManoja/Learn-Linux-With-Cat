#!/usr/bin/env bash
# Lesson: touch

LESSON_COMMAND="touch"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Now you have a folder, let's put something in it!
The 'touch' command creates a brand new, empty file.
It literally 'touches' the filesystem to leave a mark (a file)."

TASK_INSTRUCTION="Create a file named 'secret.txt' inside the 'mission' folder."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Nicely done! Remember, you can 'cd' into mission, 'touch' it, and 'ls' to check!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="I don't see 'secret.txt' inside the 'mission' folder."
TASK_FAIL_POSE="confused"

HINT_1="You can either 'cd mission' then 'touch secret.txt', or just 'touch mission/secret.txt'."
HINT_2="Use the touch command to create the file."
HINT_3="Type 'cd mission' and Enter, then 'touch secret.txt' and Enter."

check_task() {
    if check_file_exists "mission/secret.txt"; then
        return 0
    fi
    return 1
}
