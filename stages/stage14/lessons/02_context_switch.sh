#!/usr/bin/env bash
# Lesson: context switching

LESSON_COMMAND="context switch"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="One core runs one thing at a time. The appearance of many is a
trick performed thousands of times a second.

A CONTEXT SWITCH is the kernel saving everything about the running process -
registers, program counter, stack pointer - loading another process's saved
state, and jumping to it.

It is not free. Saving and restoring costs microseconds, and worse, the new
process arrives with cold CPU caches. Switch too often and the machine
spends its time switching instead of working.
/proc/<PID>/status counts them: voluntary_ctxt_switches (gave up waiting for
something) and nonvoluntary (was preempted)."

TASK_INSTRUCTION="Look at your own process's context switch counts in /proc/self/status."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Voluntary means it gave up the CPU waiting for something. Non-voluntary means the scheduler took it away."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Grep /proc/self/status for the switch counts."
TASK_FAIL_POSE="confused"

HINT_1="The counts are in the status file you already know."
HINT_2="grep for 'ctxt' in /proc/self/status."
HINT_3="Type: grep ctxt /proc/self/status"

check_task() {
    check_command_matches '(grep|cat|less).*(ctxt|switch).*/proc/self/status' \
        || check_command_matches '/proc/self/status'
}
