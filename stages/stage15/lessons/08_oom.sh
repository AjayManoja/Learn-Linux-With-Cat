#!/usr/bin/env bash
# Lesson: the OOM killer

LESSON_COMMAND="OOM"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="If memory runs out completely - no free frames, nothing left
to reclaim, swap full - the kernel cannot fail politely, because it has
already promised that memory.

So it picks a process and kills it. That is the OUT OF MEMORY KILLER. It
scores every process on how much it is using and how important it looks,
and kills the highest scorer with SIGKILL. No cleanup, no warning.

This is why a service can vanish with nothing in its own logs. The evidence
is in the kernel log, not the application's:
  dmesg | grep -i oom
If a process disappears and nobody knows why, check there first."

TASK_INSTRUCTION="Show this process's OOM score - the kernel publishes it at /proc/self/oom_score."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Higher means likelier to be chosen. A process using most of the machine's memory scores highest, which is usually the right answer and occasionally a disaster."
TASK_SUCCESS_POSE="celebrate"

TASK_FAIL_MSG="Read /proc/self/oom_score."
TASK_FAIL_POSE="confused"

HINT_1="Another file in the /proc/self directory."
HINT_2="It is called oom_score."
HINT_3="Type: cat /proc/self/oom_score"

check_task() {
    check_command_matches '(cat|less|head).*/proc/[0-9a-z]+/oom_score'
}
