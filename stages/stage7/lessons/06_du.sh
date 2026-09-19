#!/usr/bin/env bash
# Lesson: du

LESSON_COMMAND="du"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'du' — disk usage — says how much space things take.
  du -h media
'-h' means human-readable: 4.0K, 1.2M, instead of raw block counts.
Add '-s' for a summary — one total for the whole directory rather than a
line for every file inside it. 'du -sh' is the pair you will type most."

TASK_INSTRUCTION="Show the total size of the media directory in human-readable form."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="One number for the whole directory. -s summarises, -h makes it readable."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use du with -s and -h on media."
TASK_FAIL_POSE="confused"

HINT_1="You want one total, in units a person can read."
HINT_2="-s summarises and -h humanises; they combine."
HINT_3="Type: du -sh media"

check_task() {
    check_command_matches '^du +.*-[a-z]*s[a-z]*h?[a-z]* +.*media' \
        || check_command_matches '^du +.*-h.*-s.* +.*media'
}
