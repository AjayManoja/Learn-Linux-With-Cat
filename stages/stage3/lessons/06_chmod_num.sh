#!/usr/bin/env bash
# Lesson: chmod with numbers

LESSON_COMMAND="chmod"
# Where the player must be standing for these instructions to make sense.
LESSON_START_DIR="work"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Now you change them. 'chmod' sets permissions.
The numeric form adds up three values per audience:
  read = 4, write = 2, execute = 1
So 6 is read+write, 5 is read+execute, 7 is all three, 0 is nothing.
'chmod 644 file' means owner 6 (rw), group 4 (r), everyone 4 (r).
That 644 is the normal setting for an ordinary file."

TASK_INSTRUCTION="Make draft.txt private to you: 'chmod 600 draft.txt' (owner read+write, nobody else anything)."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="600 — yours alone. Check it with 'ls -l' if you like."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="draft.txt needs mode 600. Owner 6, group 0, others 0."
TASK_FAIL_POSE="confused"

HINT_1="Read is 4, write is 2. Add them for the owner, give the others nothing."
HINT_2="The three digits are owner, group, everyone else."
HINT_3="Type: chmod 600 draft.txt"

check_task() {
    # Checks the resulting mode, not the command text: any correct route counts.
    check_file_mode "work/draft.txt" "600"
}
