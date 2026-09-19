#!/usr/bin/env bash
# Lesson: cache is not used memory

LESSON_COMMAND="buff/cache"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="This is the memory question people get wrong most often.

When you read a file, the kernel keeps its contents in RAM in the PAGE
CACHE, so the next read is free. Over time this grows until almost no
memory is 'free'.

That is not a leak and not a problem. Cache is instantly reclaimable: the
moment a process needs memory, the kernel drops cache pages and hands the
frames over. No disk write is needed, because the data is already on disk.

So 'free' being near zero means nothing. AVAILABLE is the number that
answers 'can I start another program' - it counts free memory plus the
cache the kernel would release."

TASK_INSTRUCTION="Show how much memory is cached — read the Cached line from /proc/meminfo."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="All of that is file contents the kernel is holding on to speculatively, and all of it is available the instant anything needs it."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Grep Cached out of /proc/meminfo."
TASK_FAIL_POSE="confused"

HINT_1="meminfo has a line for it."
HINT_2="grep for Cached."
HINT_3="Type: grep Cached /proc/meminfo"

check_task() {
    check_command_matches 'grep.*([Cc]ached|Available).*/proc/meminfo' \
        || check_command_matches '/proc/meminfo'
}
