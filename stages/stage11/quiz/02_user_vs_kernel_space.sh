#!/usr/bin/env bash
QUESTION="What are user space and kernel space, and why does the separation exist?"
QUESTION_HINT="Think about what would happen if any program could write to any memory address."
ANSWER_PATTERN="protect|isolat|crash|safe|secur|privileg|separat|restrict"
MODEL_ANSWER="Kernel space is privileged: code there can touch any memory, any device,
any process. User space is restricted: a program can only touch its own memory and
must ask the kernel for anything else.

The separation exists so a bug in one program cannot take down the machine. If a
text editor could write to arbitrary memory, one mistake could corrupt the kernel
or another user's data. The CPU enforces the boundary in hardware, and crossing it
requires a system call.

That is why a segfault kills one process instead of the whole system."
