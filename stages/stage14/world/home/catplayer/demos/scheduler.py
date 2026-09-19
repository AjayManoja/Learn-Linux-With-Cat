#!/usr/bin/env python3
"""Run the same set of jobs through different scheduling algorithms.

Usage:
    python3 demos/scheduler.py fcfs
    python3 demos/scheduler.py sjf
    python3 demos/scheduler.py rr 2

The jobs are fixed so the algorithms can be compared fairly. Watch the
average waiting time change while the work stays identical.
"""
import sys

# (name, arrival time, burst time)
JOBS = [
    ("A", 0, 7),
    ("B", 1, 4),
    ("C", 2, 1),
    ("D", 3, 4),
]


def show(order, start_end, algo):
    print(f"algorithm: {algo}")
    print()
    print("timeline (each block is one uninterrupted run):")
    print("  " + "  ".join(f"[{n} {s}-{e}]" for n, s, e in start_end))
    print()

    finish = {}
    for name, _, end in start_end:
        finish[name] = end

    print(f"{'job':<5}{'arrival':<9}{'burst':<7}{'finish':<8}{'turnaround':<12}{'waiting'}")
    total_wait = total_turn = 0
    for name, arrival, burst in JOBS:
        turn = finish[name] - arrival      # from arriving to finishing
        wait = turn - burst                # time spent not running
        total_turn += turn
        total_wait += wait
        print(f"{name:<5}{arrival:<9}{burst:<7}{finish[name]:<8}{turn:<12}{wait}")

    n = len(JOBS)
    print()
    print(f"average turnaround : {total_turn / n:.2f}")
    print(f"average waiting    : {total_wait / n:.2f}")


def fcfs():
    """First come, first served. No preemption - each job runs to completion."""
    t = 0
    spans = []
    for name, arrival, burst in sorted(JOBS, key=lambda j: j[1]):
        t = max(t, arrival)
        spans.append((name, t, t + burst))
        t += burst
    show(None, spans, "FCFS (first come, first served)")


def sjf():
    """Shortest job first, non-preemptive. Picks the shortest job available."""
    t = 0
    spans = []
    remaining = list(JOBS)
    while remaining:
        ready = [j for j in remaining if j[1] <= t] or [min(remaining, key=lambda j: j[1])]
        name, arrival, burst = min(ready, key=lambda j: j[2])
        t = max(t, arrival)
        spans.append((name, t, t + burst))
        t += burst
        remaining.remove((name, arrival, burst))
    show(None, spans, "SJF (shortest job first)")


def round_robin(quantum):
    """Each job gets the CPU for at most `quantum` units, then goes to the back.

    The queue discipline is the whole algorithm: a job that has not finished
    rejoins the queue BEHIND anything that arrived while it was running.
    """
    order = sorted(JOBS, key=lambda j: j[1])
    left = {name: burst for name, _, burst in JOBS}
    arrival = {name: a for name, a, _ in JOBS}

    t = 0
    queue = []
    admitted = set()   # entered the system once; never re-admitted
    spans = []

    def admit(now):
        # Only jobs that have never entered the queue. A job that is running
        # or waiting is already accounted for - re-admitting it here would
        # schedule it twice.
        for name, a, _ in order:
            if a <= now and name not in admitted:
                queue.append(name)
                admitted.add(name)

    admit(t)
    while queue or any(v > 0 for v in left.values()):
        if not queue:
            # CPU idle until the next job arrives.
            future = [a for n, a, _ in order if left[n] > 0 and a > t]
            if not future:
                break
            t = min(future)
            admit(t)
            continue

        name = queue.pop(0)

        slice_len = min(quantum, left[name])
        spans.append((name, t, t + slice_len))
        t += slice_len
        left[name] -= slice_len

        # Anything that arrived during this slice queues ahead of the job
        # that was just running - that ordering is what makes it round robin.
        admit(t)
        if left[name] > 0:
            queue.append(name)

    # Merge adjacent slices of the same job so the timeline reads cleanly.
    merged = []
    for span in spans:
        if merged and merged[-1][0] == span[0] and merged[-1][2] == span[1]:
            merged[-1] = (span[0], merged[-1][1], span[2])
        else:
            merged.append(span)

    show(None, merged, f"Round robin (quantum = {quantum})")


if __name__ == "__main__":
    algo = sys.argv[1] if len(sys.argv) > 1 else "fcfs"
    if algo == "fcfs":
        fcfs()
    elif algo == "sjf":
        sjf()
    elif algo == "rr":
        q = int(sys.argv[2]) if len(sys.argv) > 2 else 2
        round_robin(q)
    else:
        print(__doc__)
