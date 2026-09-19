#!/usr/bin/env bash
# Lesson: starvation, and the fix for deadlock

LESSON_COMMAND="lock ordering"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="First the fix. Take the locks in the same order everywhere and
circular wait becomes impossible. Same locks, same work, no deadlock -
ordered_demo.py is the identical program with one change.

Then the third failure: STARVATION. A thread that is never deadlocked and
never blocked forever, but keeps losing. Higher-priority threads keep
arriving and it never gets scheduled.

Deadlock is nobody progressing. Starvation is somebody never progressing
while others do. Deadlock you can detect; starvation just looks slow."

TASK_INSTRUCTION="Run demos/ordered_demo.py and watch the same two locks complete without deadlocking."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="No deadlock, and nothing changed but the order. That is the cheapest fix in concurrency."
TASK_SUCCESS_POSE="celebrate"

TASK_FAIL_MSG="Run it: python3 demos/ordered_demo.py"
TASK_FAIL_POSE="confused"

HINT_1="The deadlock demo with the lock order corrected."
HINT_2="Run ordered_demo.py."
HINT_3="Type: python3 demos/ordered_demo.py"

check_task() {
    check_command_matches '^(python3?|timeout +[0-9]+ +python3?) +.*ordered_demo\.py'
}
