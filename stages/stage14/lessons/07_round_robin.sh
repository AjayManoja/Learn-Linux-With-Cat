#!/usr/bin/env bash
# Lesson: round robin

LESSON_COMMAND="round robin"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="ROUND ROBIN gives everyone a slice in turn. Unfinished jobs go
to the back of the queue.

Its average waiting time is worse than both the others - 6.25 here. That
looks like a loss until you notice what it bought: C, the one-unit job,
finishes at 5 instead of 12. No job can be starved, and nothing waits behind
a long-running task.

That is the real trade: round robin optimises RESPONSIVENESS, not
throughput. Which is exactly what you want on a machine someone is sitting
in front of."

TASK_INSTRUCTION="Save a round robin run with quantum 2 to rr.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Worse average, better worst case. Three algorithms, same jobs, three different sets of winners and losers."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Redirect a round robin run into rr.txt."
TASK_FAIL_POSE="confused"

HINT_1="rr with a quantum, redirected to a file."
HINT_2="The quantum goes after rr."
HINT_3="Type: python3 demos/scheduler.py rr 2 > rr.txt"

check_task() {
    check_file_exists "rr.txt" && check_file_matches "rr.txt" 'average waiting'
}
