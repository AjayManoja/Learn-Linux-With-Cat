#!/usr/bin/env bash
QUESTION="What is a race condition? Why are they hard to find?"
QUESTION_HINT="Think about what determines the result, and whether it is the same every run."
ANSWER_PATTERN="(timing|order|schedul|interleav).*(result|outcome|depend)|depend.*(timing|order|schedul)|non.?determin|intermittent"
MODEL_ANSWER="A race condition is when the correctness of a program depends on the
order in which concurrent operations happen to run - an order nothing guarantees.

The classic case is a read-modify-write like counter = counter + 1. That is three
machine operations. If two threads interleave between the read and the write, both
read the same value, both add one, and both store the same result. One update is
silently lost.

They are hard to find because they are non-deterministic. No crash, no exception, no
stack trace - just an answer that is occasionally wrong. They often appear only
under load, which means only in production, and they usually cannot be reproduced on
demand. Tests pass; the system is still broken."
