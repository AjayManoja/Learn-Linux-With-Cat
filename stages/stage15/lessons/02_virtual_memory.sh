#!/usr/bin/env bash
# Lesson: virtual memory

LESSON_COMMAND="virtual memory"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Every process believes it has the whole machine to itself,
starting at address zero. All of them believe it simultaneously.

Each process has its own VIRTUAL ADDRESS SPACE. The addresses your code
uses are virtual; the CPU translates each one to a PHYSICAL address before
the memory chip ever sees it. Two processes using address 0x1000 are using
two different pieces of real memory.

This is the isolation from Stage 11, enforced in hardware. A process cannot
reach another's memory because it cannot even name it - there is no virtual
address that translates there."

TASK_INSTRUCTION="Read /proc/meminfo and find MemTotal - the real, physical amount."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That is the physical total. Every process can be promised more than that, and usually is."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Read /proc/meminfo, or grep MemTotal out of it."
TASK_FAIL_POSE="confused"

HINT_1="The kernel publishes memory facts as a file."
HINT_2="It is /proc/meminfo."
HINT_3="Type: grep MemTotal /proc/meminfo"

check_task() {
    check_command_matches '(grep|cat|head|less).*/proc/meminfo'
}
