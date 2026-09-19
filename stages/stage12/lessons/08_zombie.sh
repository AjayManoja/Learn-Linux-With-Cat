#!/usr/bin/env bash
# Lesson: zombies

LESSON_COMMAND="zombie"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A zombie is a process that has finished but has not been
cleaned up.

When a child exits, the kernel keeps one small record - its exit status -
so the parent can ask how it went. The parent collects it by calling
wait(). That collection is called REAPING. Once reaped, the record is
freed and the process is properly gone.

If the parent never calls wait(), the record stays. That record is the
zombie. It uses no memory and no CPU; it occupies a slot in the process
table. Thousands of them will exhaust that table.

You cannot kill a zombie - it is already dead. You fix its PARENT."

TASK_INSTRUCTION="Run demos/zombie_demo.py in the background, then find the zombie it creates with ps."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="There it is, state Z. Killing it would do nothing - it is already dead. The bug is in the parent that never reaped it."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run the demo in the background, then look for state Z in ps."
TASK_FAIL_POSE="confused"

HINT_1="Run the demo in the background so you get your prompt back to look around."
HINT_2="python3 demos/zombie_demo.py &  then run ps and look at the STAT column."
HINT_3="Type: python3 demos/zombie_demo.py &   then: ps -o pid,ppid,stat,comm"

check_task() {
    check_command_matches '^ps +.*stat'
}
