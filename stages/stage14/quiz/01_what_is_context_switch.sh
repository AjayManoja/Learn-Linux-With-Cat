#!/usr/bin/env bash
QUESTION="What is a context switch, and why is it expensive?"
QUESTION_HINT="Something has to be saved before something else can be loaded."
ANSWER_PATTERN="(save|store).*(state|register|context)|(load|restore).*(state|register|context)|cache|overhead"
MODEL_ANSWER="A context switch is the kernel saving the state of the running process -
registers, program counter, stack pointer, memory mappings - loading another
process's saved state, and resuming it. It is what makes one core look like many.

The direct cost is small: a few microseconds of saving and restoring. The indirect
cost is larger. The new process arrives with cold CPU caches and, on a process
switch rather than a thread switch, a flushed TLB. It then runs slowly until those
refill.

This is why very short time slices hurt: past a point the machine spends more time
switching than working. It is also why switching between threads of one process is
cheaper than between processes - the address space does not change."
