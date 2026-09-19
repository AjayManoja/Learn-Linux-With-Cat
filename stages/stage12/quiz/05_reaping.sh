#!/usr/bin/env bash
QUESTION="What does it mean to reap a process, and what happens if a program never does it?"
QUESTION_HINT="Think about who needs to know how a child exited, and where that information is kept."
ANSWER_PATTERN="wait|reap.*(exit status|collect|status)|zombie|process table|slot|leak"
MODEL_ANSWER="Reaping is a parent calling wait() or waitpid() to collect a finished
child's exit status. Until it does, the kernel must keep a process table entry
holding that status, because the parent might still ask.

A program that forks children and never waits on them leaks those entries. Each one
is a zombie: no memory, no CPU, just a slot in a table of fixed size. Enough of them
and the table fills and the machine cannot start new processes at all.

The fix is in the parent - call wait(), or handle SIGCHLD, or explicitly ignore
SIGCHLD so the kernel reaps automatically. Killing the zombies does nothing; they
are already dead. Killing the parent works, because init then adopts and reaps them."
