#!/usr/bin/env bash
QUESTION="What is the difference between preemptive and non-preemptive scheduling?"
QUESTION_HINT="Who decides when a running process stops running?"
ANSWER_PATTERN="(preempt.*(take|force|interrupt|timer|kernel))|(non.?preempt.*(until|finish|block|voluntar|keep))|runs to completion"
MODEL_ANSWER="Under non-preemptive scheduling a process keeps the CPU until it blocks or
exits. The scheduler only chooses again when the running process gives up
voluntarily. Simple and cheap - and one runaway loop hangs the machine.

Under preemptive scheduling the kernel can take the CPU away. A timer interrupt
fires, control returns to the kernel, and it may switch. Linux is preemptive.

That is why an infinite loop in a user program does not freeze Linux: the timer
interrupt does not care what the loop wants. The cost is more context switches, and
the need for locking - because a process can now be interrupted mid-update, which is
exactly the race condition problem from Stage 13."
