#!/usr/bin/env bash
QUESTION="What is PID 1, and why does every process have a parent?"
QUESTION_HINT="There is only one way to create a process on Linux."
ANSWER_PATTERN="(init|systemd)|pid 1.*(first|kernel|start|ancestor|root)|fork.*(only|every|create)"
MODEL_ANSWER="PID 1 is init - systemd on most modern distributions. The kernel starts
it directly at boot, and it is the ancestor of everything else.

Every other process has a parent because fork() is the only way to create one: an
existing process duplicates itself. So the process table is a tree, and PID 1 is
the root.

PID 1 has two special jobs: it adopts orphans, and it reaps them. That is why an
orphaned process is not a leak - init inherits it and cleans up when it exits. If
PID 1 dies, the kernel panics, because there is nothing left to adopt anything."
