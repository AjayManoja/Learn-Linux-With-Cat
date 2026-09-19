#!/usr/bin/env bash
# Lesson: sed s///

LESSON_COMMAND="sed"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'sed' edits a stream of text as it goes past.
Its substitute command reads: s/what/with-what/
  sed 's/dog/cat/' memo.txt
replaces the first 'dog' on each line with 'cat'.
The quotes matter — the shell would otherwise try to read the slashes.
And again: the file on disk does not change."

TASK_INSTRUCTION="Replace 'dog' with 'cat' in data/memo.txt using sed."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A rewritten memo, and the original untouched. Much better."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use sed with s/dog/cat/ on data/memo.txt."
TASK_FAIL_POSE="confused"

HINT_1="The pattern is s/old/new/ — substitute."
HINT_2="Wrap it in quotes so the shell leaves the slashes alone."
HINT_3="Type: sed 's/dog/cat/' data/memo.txt"

check_task() {
    check_command_matches "^sed +.*s[/|#]dog[/|#]cat[/|#].* +.*memo\.txt$"
}
