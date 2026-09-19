#!/usr/bin/env bash
# Lesson: deadlock

LESSON_COMMAND="deadlock"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Locks fix races and introduce a new failure: DEADLOCK.

Thread A holds lock 1 and wants lock 2.
Thread B holds lock 2 and wants lock 1.

Neither can proceed and neither will give up. The program does not crash -
it stops, forever, using no CPU at all. That is why a deadlocked service
looks healthy on a CPU graph.

Four conditions must all hold for deadlock: mutual exclusion, hold-and-wait,
no preemption, and circular wait. Break any one and it cannot happen. The
easy one to break is circular wait - agree on a lock order."

TASK_INSTRUCTION="Run demos/deadlock_demo.py and watch both threads wait for each other."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Both stuck, no CPU used, no error. In production this is the service that stops responding but never crashes."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run it: python3 demos/deadlock_demo.py"
TASK_FAIL_POSE="confused"

HINT_1="It gives up after five seconds, so it is safe to run."
HINT_2="Run deadlock_demo.py."
HINT_3="Type: python3 demos/deadlock_demo.py"

check_task() {
    check_command_matches '^(python3?|timeout +[0-9]+ +python3?) +.*deadlock_demo\.py'
}
