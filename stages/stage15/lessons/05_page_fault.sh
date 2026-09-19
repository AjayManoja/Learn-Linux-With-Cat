#!/usr/bin/env bash
# Lesson: page faults

LESSON_COMMAND="page fault"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A PAGE FAULT is not an error. It is the normal mechanism by
which memory gets allocated.

Your program touches a virtual address. The CPU looks it up, finds no
frame mapped, and traps into the kernel. The kernel finds a free frame,
maps it, and returns. Your program resumes, unaware.

  MINOR fault - the page was resolved from RAM: a fresh zero page, or one
                already in the page cache. Microseconds.
  MAJOR fault - the page had to be read from disk. Milliseconds. Thousands
                of times slower.

Minor faults are constant and healthy. Major faults in bulk are what a
struggling machine feels like."

TASK_INSTRUCTION="Look at your shell's fault counts - grep /proc/self/stat is awkward, so use /proc/self/status and find VmRSS instead."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="RSS is how much is really resident. Every kilobyte of it arrived through a page fault."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Grep VmRSS out of /proc/self/status."
TASK_FAIL_POSE="confused"

HINT_1="The status file reports resident size."
HINT_2="grep for VmRSS."
HINT_3="Type: grep VmRSS /proc/self/status"

check_task() {
    check_command_matches '(grep|cat|less).*/proc/[0-9a-z]+/status'
}
