#!/usr/bin/env bash
# Lesson: mktemp

LESSON_COMMAND="mktemp"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Scripts often need somewhere to put working data.
Picking a name yourself is a mistake: two copies of the script running at
once will collide, and a predictable name can be hijacked.
  mktemp
creates a file with a name nothing else will have, and prints it.
Use the name it gives you. Never invent your own."

TASK_INSTRUCTION="Create a temporary file with mktemp."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A name nothing else will pick. Scripts that skip this break in ways that are very hard to find."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Just run mktemp."
TASK_FAIL_POSE="confused"

HINT_1="One command, no arguments needed."
HINT_2="The command is mktemp."
HINT_3="Type: mktemp"

check_task() {
    check_command_matches '^mktemp'
}
