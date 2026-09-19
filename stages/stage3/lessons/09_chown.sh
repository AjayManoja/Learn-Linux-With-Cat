#!/usr/bin/env bash
# Lesson: chown (and why you can't use it here)

LESSON_COMMAND="chown"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Permissions say what each audience may do. Ownership says who
the owner actually is, and 'chown' changes it: 'chown newowner file'.
Here's the catch, and it's worth knowing now: giving your file away
requires root. As an ordinary user you will get 'Operation not permitted'.
That isn't a bug — it stops people dumping files into someone else's name.
So read ownership, expect chown to need sudo, and don't be surprised."

TASK_INSTRUCTION="See who owns report.txt — the owner is the third column of 'ls -l report.txt'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That name is the owner. Changing it would need root, which the sandbox won't give you."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run 'ls -l report.txt' and look at the owner column."
TASK_FAIL_POSE="confused"

HINT_1="You already know the command that lists ownership."
HINT_2="'ls -l' prints the owner as its third column."
HINT_3="Type: ls -l report.txt"

check_task() {
    check_command_matches '^ls +-[la]*l[la]* +.*report\.txt$'
}
