#!/usr/bin/env bash
# Lesson: sed s///g

LESSON_COMMAND="sed s///g"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="By default sed replaces only the FIRST match on each line.
Add a 'g' on the end — for global — and it replaces every one:
  sed 's/the/a/g' file
This catches almost everyone once. If a substitution looks like it only
half worked, the missing 'g' is usually why."

TASK_INSTRUCTION="Replace every 'the' with 'a' in data/memo.txt — every occurrence, not just the first on each line."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Every match on every line. That trailing g is worth remembering."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Same substitution, but add g at the end so it catches them all."
TASK_FAIL_POSE="confused"

HINT_1="Your substitution is stopping after the first match on each line."
HINT_2="One letter after the final slash fixes it."
HINT_3="Type: sed 's/the/a/g' data/memo.txt"

check_task() {
    check_command_matches "^sed +.*s[/|#]the[/|#]a[/|#]g.* +.*memo\.txt$"
}
