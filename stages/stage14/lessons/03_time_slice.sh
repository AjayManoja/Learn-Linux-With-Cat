#!/usr/bin/env bash
# Lesson: the time slice

LESSON_COMMAND="time slice"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Each process gets the CPU for a limited period - a TIME SLICE,
or quantum. When it expires the scheduler takes the CPU back and gives it to
someone else.

Choosing the size is a genuine trade-off:
  short slice - every process gets a turn quickly, so the system feels
                responsive; but you pay for a context switch more often
  long slice  - less switching overhead, more work done per second; but a
                short job can sit behind a long one for ages

Interactive systems favour short slices. Batch systems favour long ones.
Linux does not use a fixed quantum at all - CFS gives each process a share
of time proportional to its weight."

TASK_INSTRUCTION="Run the scheduler simulator with round robin and a quantum of 2: python3 demos/scheduler.py rr 2"
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Look at the timeline: A is interrupted repeatedly. Short job C finished at 5 instead of waiting for A."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run the simulator with: rr 2"
TASK_FAIL_POSE="confused"

HINT_1="The simulator takes the algorithm as an argument."
HINT_2="rr means round robin; the number after it is the quantum."
HINT_3="Type: python3 demos/scheduler.py rr 2"

check_task() {
    check_command_matches '^python3? +.*scheduler\.py +rr'
}
