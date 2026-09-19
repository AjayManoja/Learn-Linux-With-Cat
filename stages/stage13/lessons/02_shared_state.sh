#!/usr/bin/env bash
# Lesson: shared state

LESSON_COMMAND="threads"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Here is the code every concurrency bug starts from:

    counter = counter + 1

One line. It looks atomic. It is not. The CPU does three separate things:

    1. read counter from memory into a register
    2. add 1
    3. write the register back to memory

Between any two of those, the scheduler is free to switch to another thread.
If it does, and that thread runs the same three steps, both read the same
old value and both write back the same new one.

One increment disappears, silently. Read the demo before you run it."

TASK_INSTRUCTION="Read demos/race_demo.py and see the three steps written out explicitly."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The read and the write are separate lines there on purpose. In real code they hide inside one innocent-looking statement."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Read the demo with cat or less."
TASK_FAIL_POSE="confused"

HINT_1="Just read the file before running it."
HINT_2="cat the demo."
HINT_3="Type: cat demos/race_demo.py"

check_task() {
    check_command_matches '^(cat|less|head|nl) +.*race_demo\.py'
}
