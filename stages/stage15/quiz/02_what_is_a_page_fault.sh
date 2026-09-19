#!/usr/bin/env bash
QUESTION="What is a page fault? What is the difference between a minor and a major one?"
QUESTION_HINT="One is resolved from RAM. The other needs the disk."
ANSWER_PATTERN="(minor.*(ram|memory|cache|no disk|zero))|(major.*(disk|read|swap|slow|io))|(not.*(mapped|present|in memory))"
MODEL_ANSWER="A page fault is the CPU trapping into the kernel because a virtual address
has no physical frame mapped to it. It is not an error - it is how memory is
actually allocated. Nothing is committed until first touch.

A MINOR fault is resolved without touching the disk: the kernel hands over a fresh
zeroed frame, or maps a page already in the page cache. It costs microseconds and
happens constantly on a healthy system.

A MAJOR fault requires reading from disk - the page was swapped out, or it is file
data not yet cached. It costs milliseconds, thousands of times more.

Minor faults in volume are normal. Major faults in volume mean the working set does
not fit in RAM, and that is what a thrashing machine feels like."
