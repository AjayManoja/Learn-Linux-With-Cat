#!/usr/bin/env bash
QUESTION="What is the OOM killer, and why would a process disappear with nothing in its own logs?"
QUESTION_HINT="Which signal cannot be caught?"
ANSWER_PATTERN="(oom|out of memory).*(kill|sigkill)|sigkill|(cannot|can.t).*(catch|handle|log)|dmesg|kernel log"
MODEL_ANSWER="When memory is genuinely exhausted - no free frames, nothing reclaimable,
swap full - the kernel cannot fail an allocation politely, because it has already
promised that memory. So it picks a victim and kills it.

The OOM killer scores every process, roughly on how much memory it is using, and
kills the highest scorer with SIGKILL. SIGKILL cannot be caught or handled, so the
process gets no chance to log anything, flush anything or shut down cleanly. It just
stops existing.

That is why the application log ends mid-sentence with no error. The evidence is in
the kernel's log instead:
    dmesg | grep -i oom

The score is readable at /proc/<pid>/oom_score, and adjustable through
oom_score_adj if you need to protect something."
