#!/usr/bin/env bash
# Review: everything from 11-15, written down

TASK_INSTRUCTION="Write os_summary.txt explaining, in your own words, five things from these stages: syscall, zombie, race condition, context switch, page fault."
TASK_CAT_POSE="thinking"
RECALLS="Stage 11 - syscall · Stage 12 - zombie · Stage 13 - race · Stage 14 - context switch · Stage 15 - page fault"

TASK_SUCCESS_MSG="Five ideas, five stages, in your own words. If you can write them you can say them, and saying them is what an interview actually tests."
TASK_SUCCESS_POSE="celebrate"
TASK_FAIL_MSG="All five terms need to appear in os_summary.txt - one line each is plenty."
TASK_FAIL_POSE="confused"

HINT_1="One line each. The point is writing it in your words, not mine."
HINT_2="Append five lines with >>, one per term."
HINT_3="Start with: echo syscall is how user space asks the kernel for something > os_summary.txt"

setup_challenge() {
    rm -f "${SANDBOX_HOME}/os_summary.txt"
}

check_task() {
    check_file_exists "os_summary.txt" \
        && check_file_matches "os_summary.txt" '[Ss]yscall|[Ss]ystem call' \
        && check_file_matches "os_summary.txt" '[Zz]ombie' \
        && check_file_matches "os_summary.txt" '[Rr]ace' \
        && check_file_matches "os_summary.txt" '[Cc]ontext' \
        && check_file_matches "os_summary.txt" '[Pp]age fault|[Pp]agefault'
}
