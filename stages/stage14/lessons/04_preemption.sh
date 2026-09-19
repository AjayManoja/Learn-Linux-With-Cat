#!/usr/bin/env bash
# Lesson: preemption

LESSON_COMMAND="preemption"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="PREEMPTION is the scheduler taking the CPU away from a process
that has not finished and did not ask to stop.

  Non-preemptive: once running, a process keeps the CPU until it blocks or
                  exits. Simple - and one runaway process freezes everything.
  Preemptive:     a timer interrupt fires, the kernel regains control and may
                  switch. Linux is preemptive.

This is why one infinite loop does not lock up your machine. The kernel takes
the CPU back whether the loop likes it or not.
Compare two algorithms and watch the difference: FCFS never preempts."

TASK_INSTRUCTION="Run the simulator with FCFS and see what happens to the short jobs behind a long one."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="C needs one unit of CPU and does not finish until 12, because A was never interrupted. That is the convoy effect."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run the simulator with fcfs."
TASK_FAIL_POSE="confused"

HINT_1="Same simulator, different algorithm argument."
HINT_2="The argument is fcfs."
HINT_3="Type: python3 demos/scheduler.py fcfs"

check_task() {
    check_command_matches '^python3? +.*scheduler\.py +fcfs'
}
