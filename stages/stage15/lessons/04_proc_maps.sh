#!/usr/bin/env bash
# Lesson: /proc/PID/maps

LESSON_COMMAND="/proc/self/maps"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="You can read a process's entire address space layout.
  cat /proc/self/maps
Each line is one mapped region: address range, permissions, and what is
mapped there. You will see the program itself, its shared libraries, the
heap, and the stack.

Notice how many regions are shared libraries. Every process using libc maps
the same physical pages - loaded once, mapped into hundreds of address
spaces. That is why 'total memory used by all processes' always adds up to
more than the machine has."

TASK_INSTRUCTION="Show your own process's memory map."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Every region your process can legally touch, and nothing else. Anything outside those ranges is a segfault."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Read /proc/self/maps."
TASK_FAIL_POSE="confused"

HINT_1="Same /proc/self directory you used in Stage 11."
HINT_2="The file is called maps."
HINT_3="Type: cat /proc/self/maps"

check_task() {
    check_command_matches '(cat|less|head|grep|wc).*/proc/[0-9a-z]+/maps'
}
