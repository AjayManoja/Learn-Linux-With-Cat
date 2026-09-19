#!/usr/bin/env bash
# Lesson: race condition

LESSON_COMMAND="race"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A RACE CONDITION is when the result depends on the order two
threads happen to run in - an order nobody controls.

Now run it. Four threads, 2000 increments each, so 8000. You will not get
8000. Run it again and you will get a different wrong number.

That is what makes these bugs vicious: no crash, no error, no stack trace.
The program is simply wrong, intermittently, and usually only under load -
which means only in production."

TASK_INSTRUCTION="Run demos/race_demo.py and watch increments disappear."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Wrong, silently, and by a different amount each run. Now you know what people mean by 'it only happens in production'."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run it: python3 demos/race_demo.py"
TASK_FAIL_POSE="confused"

HINT_1="Run the demo you just read."
HINT_2="Use python3 to run it."
HINT_3="Type: python3 demos/race_demo.py"

check_task() {
    check_command_matches '^(python3?|timeout +[0-9]+ +python3?) +.*race_demo\.py'
}
