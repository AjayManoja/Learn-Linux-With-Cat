#!/usr/bin/env bash
QUESTION="What is the difference between fork() and exec()?"
QUESTION_HINT="One makes a second process. The other changes what a process is running."
ANSWER_PATTERN="fork.*(cop|duplicat|new process|child)|exec.*(replace|overwrit|load)|child.*parent"
MODEL_ANSWER="fork() duplicates the calling process. You get two nearly identical
processes with different PIDs, both continuing from the same line. The child gets 0
back; the parent gets the child's PID.

exec() replaces the current process image with a different program. The PID stays
the same but everything else is discarded, which is why no code after a successful
exec() ever runs.

Linux has no single 'run this program' call. The shell forks itself and the child
execs into the new program. That is exactly why your shell survives running ls:
the process that got replaced was the copy."
