#!/usr/bin/env python3
"""The same program, with a lock around the critical section.

A mutex (mutual exclusion) guarantees that only one thread is inside the
protected block at a time. The others wait.

Note what did NOT change: the read-modify-write is still three operations.
The lock does not make it atomic - it makes it uninterruptible by the other
threads that also want the lock.
"""
import threading, time

counter = 0
lock = threading.Lock()
PER_THREAD = 2000
THREADS = 4

def worker():
    global counter
    for _ in range(PER_THREAD):
        with lock:              # <-- enter the critical section
            tmp = counter
            time.sleep(0)
            counter = tmp + 1
        # <-- leave it; another thread may now enter

threads = [threading.Thread(target=worker) for _ in range(THREADS)]
for t in threads:
    t.start()
for t in threads:
    t.join()

expected = PER_THREAD * THREADS
print(f"expected : {expected}")
print(f"actual   : {counter}")
print()
print("Correct, every single time. The cost is that threads now wait for")
print("each other - a lock held too long turns parallel code back into")
print("sequential code.")
