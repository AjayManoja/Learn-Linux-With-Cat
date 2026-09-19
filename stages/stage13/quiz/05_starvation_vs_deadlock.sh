#!/usr/bin/env bash
QUESTION="What is the difference between deadlock and starvation?"
QUESTION_HINT="In one of them, nobody makes progress. In the other, somebody does."
ANSWER_PATTERN="(deadlock.*(nobody|none|no one|neither|nothing).*(progress|proceed))|(starvation.*(never|denied|keeps losing|not get|indefinite))|(others.*progress)"
MODEL_ANSWER="In a DEADLOCK, none of the involved threads can ever proceed. It is a
permanent, circular stand-off, and the system will not recover on its own. It is
detectable - you can find the cycle.

In STARVATION, the system is making progress; one particular thread just never gets
its turn. Higher-priority work keeps arriving, or an unfair lock keeps handing
access to whoever asks most aggressively. The starved thread is not blocked forever
in principle - it is simply always losing.

Deadlock is a correctness failure with a clear cause. Starvation is a fairness
failure, and it usually presents as 'this one request is mysteriously slow' rather
than as a hang. The usual fix is fair queueing or priority ageing - raising the
priority of something that has waited too long."
