#!/usr/bin/env bash
QUESTION="Name the main process states in Linux and what each one means."
QUESTION_HINT="ps prints them as single letters in the STAT column."
ANSWER_PATTERN="(running|runnable|\bR\b)|(sleep|\bS\b)|(zombie|\bZ\b)|(stopped|\bT\b)|uninterrupt|\bD\b"
MODEL_ANSWER="R - running, or sitting on the run queue ready to run.
S - interruptible sleep: waiting for something (input, a timer, a socket) and can
    be woken by a signal. Most processes are here most of the time.
D - uninterruptible sleep: usually blocked on disk I/O. It will not respond to
    signals, not even SIGKILL, until the I/O completes. Lots of D means a storage
    problem.
T - stopped: suspended by SIGSTOP or Ctrl+Z. Holds its memory, uses no CPU.
Z - zombie: exited, waiting for its parent to reap it.

A healthy machine is mostly S with a little R."
