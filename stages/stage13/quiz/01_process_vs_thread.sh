#!/usr/bin/env bash
QUESTION="What is the difference between a process and a thread?"
QUESTION_HINT="Think about what each one owns and what it shares."
ANSWER_PATTERN="(process.*(own|separate|isolat).*memory)|(thread.*shar)|(shar.*memory)|address space"
MODEL_ANSWER="A process has its own address space. Its memory is isolated - another
process cannot read or write it without going through the kernel. Creating one is
relatively expensive, and processes communicate through IPC: pipes, sockets, shared
memory segments.

A thread is a line of execution inside a process. Threads of the same process share
the address space: the same globals, the same heap, the same open file descriptors.
Each has only its own stack, registers and program counter. Creating one is cheap
and communication is free, because there is nothing to send.

The trade: sharing makes threads fast and dangerous. A bug in one thread can corrupt
another's data; a bug in one process cannot."
