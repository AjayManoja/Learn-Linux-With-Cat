#!/usr/bin/env bash
QUESTION="What is the difference between a zombie process and an orphan process?"
QUESTION_HINT="One has a parent that is ignoring it. The other has no parent at all."
ANSWER_PATTERN="zombie.*(dead|exit|finish|terminat|reap|wait)|orphan.*(parent.*(died|dead|exit|gone)|init|pid 1|adopt)|reparent"
MODEL_ANSWER="An ORPHAN is a running process whose parent has died. The kernel
immediately re-parents it to PID 1 (init/systemd), which will reap it properly
when it finishes. Orphans are harmless and handled automatically.

A ZOMBIE is a process that has already exited, but whose parent has not called
wait() to collect its exit status. The kernel keeps a small entry in the process
table so the parent can still ask how it went. That entry is the zombie. It shows
state Z in ps.

The key difference: an orphan is alive with no parent; a zombie is dead with a
negligent parent. You cannot kill a zombie - it is already dead. You fix or kill
the PARENT, and then init adopts and reaps the leftover."
