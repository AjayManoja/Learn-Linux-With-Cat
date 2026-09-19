#!/usr/bin/env bash
# Lesson: the critical section

LESSON_COMMAND="critical section"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="The fix starts with naming the problem.

A CRITICAL SECTION is a piece of code that must not be run by two threads
at once. In the demo it is exactly three lines - read, modify, write.

Identifying it is the hard part. Everything outside it can run in parallel
safely; everything inside must be one thread at a time. Make it too big and
you lose all your parallelism. Make it too small and you still have the bug.

Run the race again and confirm it is unreliable, not just wrong once."

TASK_INSTRUCTION="Run demos/race_demo.py a second time and compare the number with your first run."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A different wrong answer. Nothing about the program changed - only the timing did."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run the race demo again."
TASK_FAIL_POSE="confused"

HINT_1="Exactly the same command as last time."
HINT_2="Run race_demo.py once more."
HINT_3="Type: python3 demos/race_demo.py"

check_task() {
    check_command_matches '^(python3?|timeout +[0-9]+ +python3?) +.*race_demo\.py'
}
