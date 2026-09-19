#!/usr/bin/env bash
# Lesson: SJF

LESSON_COMMAND="SJF"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="SHORTEST JOB FIRST picks the shortest available job each time.

It is provably optimal for average waiting time - no other order beats it.
Same four jobs, same total work, average waiting drops from 6.00 to 5.25
purely by reordering.

So why does nothing use it? Because it requires knowing how long each job
will take, and you do not. Real schedulers estimate from recent behaviour.
And it starves long jobs: a steady supply of short ones means the long job
never runs at all."

TASK_INSTRUCTION="Save the SJF results to sjf.txt and compare the average waiting time with FCFS."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="5.25 against 6.00. Identical work, better average, just a different order."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Redirect the sjf run into sjf.txt."
TASK_FAIL_POSE="confused"

HINT_1="Same as the last lesson with a different algorithm."
HINT_2="The argument is sjf."
HINT_3="Type: python3 demos/scheduler.py sjf > sjf.txt"

check_task() {
    check_file_exists "sjf.txt" && check_file_matches "sjf.txt" 'average waiting'
}
