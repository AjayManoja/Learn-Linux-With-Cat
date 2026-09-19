#!/usr/bin/env bash
# Lesson: mutex

LESSON_COMMAND="mutex"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A MUTEX - mutual exclusion - is a lock. One thread holds it at a
time; everyone else waits.

Wrap the critical section in a lock and the race is gone. Not reduced -
gone. The result is correct every run, forever.

What it costs: threads now wait for each other. A lock held across slow
work (a network call, a disk read) turns your parallel program back into a
sequential one with extra overhead. Hold locks for as little time as
possible."

TASK_INSTRUCTION="Run demos/mutex_demo.py and confirm the count is now exactly right."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="8000, every time. Same three operations - the lock just stopped anyone else running them at the same moment."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run it: python3 demos/mutex_demo.py"
TASK_FAIL_POSE="confused"

HINT_1="The fixed version of the demo you just ran."
HINT_2="Run mutex_demo.py."
HINT_3="Type: python3 demos/mutex_demo.py"

check_task() {
    check_command_matches '^(python3?|timeout +[0-9]+ +python3?) +.*mutex_demo\.py'
}
