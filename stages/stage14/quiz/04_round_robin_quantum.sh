#!/usr/bin/env bash
QUESTION="In round robin scheduling, what happens if the time quantum is too large or too small?"
QUESTION_HINT="At one extreme it stops being round robin. At the other it stops doing work."
ANSWER_PATTERN="(too (large|big|long).*(fcfs|first come))|(too (small|short).*(overhead|switch|context))|overhead.*switch|switch.*overhead"
MODEL_ANSWER="If the quantum is too large, every job finishes inside its slice and round
robin degenerates into FCFS - complete with the convoy effect it was meant to avoid.

If the quantum is too small, the scheduler switches constantly and context-switch
overhead dominates. The machine is busy without getting work done, and cold caches
make every process slower.

The rule of thumb: the quantum should be comfortably larger than a context switch,
but short enough that a typical interactive request completes within a few rounds -
historically tens of milliseconds. Linux's CFS avoids the choice entirely by
allocating proportional shares of time rather than a fixed quantum."
