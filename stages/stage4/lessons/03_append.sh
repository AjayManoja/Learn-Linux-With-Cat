#!/usr/bin/env bash
# Lesson: >> append

LESSON_COMMAND=">>"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'>' overwrites. '>>' adds to the end.
That one extra character is the difference between keeping a log
and destroying it every time you write to it.
When you're not sure which you want, you almost always want '>>'."

TASK_INSTRUCTION="Add a second line to owner.txt using >> (don't overwrite what's there)."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Two lines. The first one survived, because you appended instead of replacing."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="owner.txt needs a second line, added with >> rather than >."
TASK_FAIL_POSE="confused"

HINT_1="You want to add without destroying."
HINT_2="Double the redirect symbol: >>"
HINT_3="Type: echo stage4 >> owner.txt"

check_task() {
    # Two lines proves they appended; overwriting would leave one.
    local f="${SANDBOX_HOME}/owner.txt"
    [[ -f "$f" ]] && [[ "$(wc -l < "$f")" -ge 2 ]]
}
