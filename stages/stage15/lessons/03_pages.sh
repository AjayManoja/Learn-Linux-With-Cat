#!/usr/bin/env bash
# Lesson: pages and frames

LESSON_COMMAND="pages"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Translation does not happen per byte - that would need a table
the size of memory. It happens per PAGE.

  page        a fixed-size block of virtual memory, almost always 4096 bytes
  page frame  a physical block of the same size in RAM
  page table  the per-process map from pages to frames

The kernel keeps a page table for each process and the CPU walks it on
every access, cached in hardware by the TLB.

The consequence: memory is allocated in whole pages. Ask for one byte and
you get 4096. That is why a program with thousands of tiny allocations uses
far more memory than the arithmetic suggests."

TASK_INSTRUCTION="Run demos/memory_demo.py and watch address space grow without using any RAM."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="256 MB reserved, almost no RSS, no faults. Reserving address space is nearly free - only touching it costs."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run it: python3 demos/memory_demo.py"
TASK_FAIL_POSE="confused"

HINT_1="The demo reserves memory in steps and reports what the kernel says."
HINT_2="Run it with python3."
HINT_3="Type: python3 demos/memory_demo.py"

check_task() {
    check_command_matches '^(python3?|timeout +[0-9]+ +python3?) +.*memory_demo\.py'
}
