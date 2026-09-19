#!/usr/bin/env bash
# Lesson: load average

LESSON_COMMAND="uptime"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Load average is the most misread number in Linux.
  uptime
gives three figures: average over 1, 5 and 15 minutes. They are not
percentages. They count processes that are running OR waiting to run.

Compare against your core count. On 4 cores:
  load 4.0  - fully busy, nothing queued
  load 8.0  - twice as much work as there are cores; everything waits
  load 0.5  - mostly idle
On Linux the figure also includes processes blocked on disk, so a high
load with idle CPUs usually means storage, not compute."

TASK_INSTRUCTION="Show the current load average."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Three numbers, one per window. Rising means work is arriving faster than it is finishing."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run uptime, or read /proc/loadavg."
TASK_FAIL_POSE="confused"

HINT_1="One command reports how long the machine has been up, and the load."
HINT_2="uptime - or read /proc/loadavg directly."
HINT_3="Type: uptime"

check_task() {
    check_command_matches '^uptime' || check_command_matches '/proc/loadavg'
}
