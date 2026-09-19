#!/usr/bin/env bash
QUESTION="What is swap, and is a machine using swap necessarily in trouble?"
QUESTION_HINT="Think about the difference between pages sitting in swap and pages moving through it."
ANSWER_PATTERN="(disk|storage).*(page|memory|ram)|(swap.*(disk|out|not.*bad|fine|normal|idle))|(thrash)"
MODEL_ANSWER="Swap is disk space the kernel uses to hold pages evicted from RAM. When
memory runs short it writes the least recently used pages out and reuses their
frames. It lets a machine run a working set larger than its RAM.

Swap being in USE is not a problem. Genuinely idle pages - a daemon that started at
boot and has done nothing since - are better on disk than occupying RAM that could
be cache.

Swap being actively READ AND WRITTEN is the problem. That means the working set no
longer fits, so every page evicted is needed again immediately. That is thrashing:
the machine spends its time moving pages instead of running programs, and it feels
completely frozen while showing low CPU usage.

So look at swap I/O rate, not swap occupancy."
