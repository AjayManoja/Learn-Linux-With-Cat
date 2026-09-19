#!/usr/bin/env bash
# Lesson: chmod with symbols

LESSON_COMMAND="chmod +/-"
# Where the player must be standing for these instructions to make sense.
LESSON_START_DIR="work"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Numbers replace every permission at once. Sometimes you want to
change just one thing and leave the rest alone. That's the symbolic form:
  u = user (owner)   g = group   o = others   a = all
  + adds a permission, - removes one
'chmod g+r file' gives the group read access and touches nothing else.
'chmod o-r file' takes read away from everyone else."

TASK_INSTRUCTION="Give the group read access to draft.txt without disturbing anything else."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="640 now. You added exactly one permission and left the rest alone."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="draft.txt should end up at 640 — group gains read, nothing else changes."
TASK_FAIL_POSE="confused"

HINT_1="You want to add one permission for one audience."
HINT_2="'g' is the group and '+r' adds read."
HINT_3="Type: chmod g+r draft.txt"

check_task() {
    check_file_mode "work/draft.txt" "640"
}
