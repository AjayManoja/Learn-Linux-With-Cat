#!/usr/bin/env bash
# Lesson: diff -u

LESSON_COMMAND="diff -u"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'diff -u' prints a unified diff — changed lines marked '-'
and '+', with a few unchanged lines around them for context.
This is the format every code review and every patch file uses, so it is
the one worth recognising. The '@@' line says which line numbers you are
looking at."

TASK_INSTRUCTION="Compare the two charter files again, this time as a unified diff."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Minus for gone, plus for added, context around both. You will see this format for the rest of your life."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Same two files, but add -u."
TASK_FAIL_POSE="confused"

HINT_1="One flag changes the output format."
HINT_2="The flag is -u, for unified."
HINT_3="Type: diff -u documents/charter.txt documents/charter_v2.txt"

check_task() {
    check_command_matches '^diff +.*-u.*charter.*charter'
}
