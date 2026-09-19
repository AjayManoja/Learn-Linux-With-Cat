#!/usr/bin/env bash
# Lesson: orphans

LESSON_COMMAND="orphan"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="What happens to a child when its parent dies first?
Nothing bad. The kernel notices and re-parents it to PID 1, which will
clean up after it properly. A process whose parent died is an ORPHAN, and
orphans are adopted immediately.
This matters because people confuse orphans with zombies. They are
opposites: an orphan has no parent and is fine. A zombie has a parent that
is alive and ignoring it - and that is the problem.
Run the demo and watch a PPID change while you look at it."

TASK_INSTRUCTION="Run demos/orphan_demo.py, then read orphan_report.txt to see who adopted the child."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The PPID changed to 1 the moment its parent died. That is adoption, and it is automatic."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run the demo with python3, then read orphan_report.txt."
TASK_FAIL_POSE="confused"

HINT_1="Run the demo first, wait a couple of seconds, then read the report it writes."
HINT_2="python3 demos/orphan_demo.py, then cat orphan_report.txt"
HINT_3="Type: python3 demos/orphan_demo.py   then: cat orphan_report.txt"

check_task() {
    check_command_matches '^(cat|less|head) +.*orphan_report\.txt' \
        && check_file_exists "orphan_report.txt"
}
