#!/usr/bin/env bash
# Lesson: swap

LESSON_COMMAND="swap"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="When RAM runs short the kernel needs frames, so it writes the
least recently used pages out to disk and reuses their frames. That is
SWAPPING, and the disk area is SWAP.

It means a machine can run more than it has RAM for. It also means that
touching a swapped-out page costs a major fault - a disk read - instead of
a memory access.

A little swap in use is fine; pages that are genuinely idle should be on
disk. Constant swapping is THRASHING: the working set no longer fits, so
every page the kernel evicts is needed again immediately, and the machine
spends its time moving pages instead of running programs."

TASK_INSTRUCTION="Check whether this machine has any swap in use — free shows it on its own line."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Swap in use is not automatically bad. Swap being read constantly is."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run free, or grep Swap out of /proc/meminfo."
TASK_FAIL_POSE="confused"

HINT_1="The same summary command as the first lesson shows a swap row."
HINT_2="free -h, or grep Swap /proc/meminfo."
HINT_3="Type: free -h"

check_task() {
    check_command_matches '^free' || check_command_matches '[Ss]wap.*/proc/meminfo|/proc/meminfo'
}
