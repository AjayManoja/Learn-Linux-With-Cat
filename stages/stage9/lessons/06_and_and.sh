#!/usr/bin/env bash
# Lesson: &&

LESSON_COMMAND="&&"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Now the payoff. '&&' means: run the second command only if the
first succeeded.
  mkdir photos && cd photos
If mkdir fails, the cd never happens, so you do not end up somewhere
unexpected. This is why you will see && everywhere in install
instructions: each step depends on the one before it working.
The sandbox has refused this until now. From here it is yours."

TASK_INSTRUCTION="Create a directory called archive and, only if that worked, list it — joined with &&."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Two commands, one condition. If the first had failed you would have seen nothing after it."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Join mkdir and ls with && on one line."
TASK_FAIL_POSE="confused"

HINT_1="Two commands on one line, the second conditional on the first."
HINT_2="The operator is two ampersands."
HINT_3="Type: mkdir archive && ls archive"

check_task() {
    check_command_matches '&&' && check_dir_exists "archive"
}
