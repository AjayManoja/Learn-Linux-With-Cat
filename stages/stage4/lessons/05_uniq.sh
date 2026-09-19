#!/usr/bin/env bash
# Lesson: uniq

LESSON_COMMAND="uniq"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'uniq' removes repeated lines — but only when they sit next to
each other. Scattered duplicates it will happily ignore.
That sounds like a flaw. It isn't: it's why 'sort' and 'uniq' are almost
always used together, and the next lesson joins them.
'uniq -c' is the useful form: it counts how many times each line repeated."

TASK_INSTRUCTION="Run 'uniq' on data/sightings.txt and notice how little it removes."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Barely changed anything, because the duplicates aren't adjacent. That's the setup for the next lesson."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Try 'uniq' on data/sightings.txt."
TASK_FAIL_POSE="confused"

HINT_1="A command that collapses neighbouring duplicate lines."
HINT_2="The command is 'uniq'."
HINT_3="Type: uniq data/sightings.txt"

check_task() {
    check_command_matches '^uniq( +-[a-z]+)* +.*sightings\.txt$'
}
