#!/usr/bin/env bash
# Lesson: whoami

LESSON_COMMAND="whoami"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Permissions are about who you are, so start there.
'whoami' prints the name of the user you are logged in as.
Every file you create belongs to that user, and the permission rules
are applied by comparing you against the file's owner."

TASK_INSTRUCTION="Find out who you are with 'whoami'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That's you. The system checks that name every time you touch a file."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Just type 'whoami' on its own."
TASK_FAIL_POSE="confused"

HINT_1="The command asks the question literally."
HINT_2="One word, no arguments."
HINT_3="Type: whoami"

check_task() {
    check_command_matches '^whoami$'
}
