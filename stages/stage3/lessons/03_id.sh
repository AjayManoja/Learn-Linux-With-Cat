#!/usr/bin/env bash
# Lesson: id

LESSON_COMMAND="id"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="You are not only a user — you also belong to groups.
'id' shows your user id, your group id, and every group you're in.
This matters because a file's permissions are set separately for
its owner, for its group, and for everyone else. Three audiences."

TASK_INSTRUCTION="Show your user and group identity with 'id'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="User, group, and everyone else — remember those three. They're the whole model."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Type 'id' on its own."
TASK_FAIL_POSE="confused"

HINT_1="Two letters. It shows your identity numbers."
HINT_2="The command is 'id'."
HINT_3="Type: id"

check_task() {
    check_command_matches '^id$'
}
