#!/usr/bin/env bash
# Lesson: FCFS and the convoy effect

LESSON_COMMAND="FCFS"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="FIRST COME, FIRST SERVED runs jobs in arrival order, each to
completion. It is the simplest possible policy and it is obviously fair.

It is also often terrible. One long job at the front makes everything behind
it wait, however small those jobs are - the CONVOY EFFECT. It is the
supermarket queue behind the full trolley.

In the simulation, C needs a single unit of CPU and waits nine.
Average waiting time: 6.00. Remember that number."

TASK_INSTRUCTION="Save the FCFS results to fcfs.txt so you can compare them later."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="6.00 average waiting. Now let's see if a different order does better on exactly the same jobs."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Redirect the fcfs run into fcfs.txt."
TASK_FAIL_POSE="confused"

HINT_1="Run it as before, but send the output to a file."
HINT_2="Use > to redirect."
HINT_3="Type: python3 demos/scheduler.py fcfs > fcfs.txt"

check_task() {
    check_file_exists "fcfs.txt" && check_file_matches "fcfs.txt" 'average waiting'
}
