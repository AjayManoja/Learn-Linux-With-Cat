#!/usr/bin/env bash
# Lesson: chmod +x

LESSON_COMMAND="chmod +x"
# Where the player must be standing for these instructions to make sense.
LESSON_START_DIR="work"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="The execute bit is the interesting one.
A file with x can be run as a program. Without it, the system refuses,
even if the file contains perfectly good instructions.
'chmod +x file' is how every script you ever write becomes runnable.
Remember this one — Stage 5 depends on it entirely."

TASK_INSTRUCTION="Make greet.sh executable with 'chmod +x'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="It's a program now. The only thing that changed was one bit."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="greet.sh still isn't executable. Use chmod +x on it."
TASK_FAIL_POSE="confused"

HINT_1="A file needs the execute bit before it can run."
HINT_2="'+x' adds that bit."
HINT_3="Type: chmod +x greet.sh"

check_task() {
    check_file_executable "work/greet.sh"
}
