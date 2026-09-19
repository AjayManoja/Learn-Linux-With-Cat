#!/usr/bin/env bash
# Lesson: sed /pattern/d

LESSON_COMMAND="sed /d"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="sed can delete lines as well as change them:
  sed '/sofa/d' file
prints the file with every line containing 'sofa' removed.
Notice this is the opposite of grep. 'grep sofa' keeps only those lines;
'sed /sofa/d' keeps everything else. Two ways to say the same filter."

TASK_INSTRUCTION="Print data/memo.txt with the line about the sofa removed."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The inconvenient rule, quietly deleted. grep keeps, sed can drop."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use sed with /sofa/d on data/memo.txt."
TASK_FAIL_POSE="confused"

HINT_1="You want everything except the matching line."
HINT_2="The delete command is a pattern in slashes followed by d."
HINT_3="Type: sed '/sofa/d' data/memo.txt"

check_task() {
    check_command_matches "^sed +.*/sofa/d.* +.*memo\.txt$"
}
