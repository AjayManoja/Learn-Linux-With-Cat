#!/usr/bin/env bash
# Lesson: find -mmin / -mtime

LESSON_COMMAND="find -mmin"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Files remember when they were last changed, and find can ask.
  find . -mmin -60
finds everything modified in the last 60 minutes. '-mtime -1' does the
same in days.
The sign convention is the same as -size and just as easy to get backwards:
'-60' is 'less than 60 minutes ago', so recent. '+60' is older than that."

TASK_INSTRUCTION="Find everything below your home that changed in the last 60 minutes."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Everything touched recently — which, in a sandbox built minutes ago, is most of it."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use find with -mmin and -60."
TASK_FAIL_POSE="confused"

HINT_1="Files know when they were last modified."
HINT_2="-mmin takes minutes; a leading minus means 'more recently than'."
HINT_3="Type: find . -mmin -60"

check_task() {
    check_command_matches '^find +.*-(mmin|mtime) +-[0-9]+'
}
