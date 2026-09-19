#!/usr/bin/env python3
"""The deadlock, fixed - by agreeing on an order.

Both threads now take lock_one before lock_two. Nothing else changed: same
two locks, same work, same sleeps. It completes immediately.

Consistent lock ordering is the standard fix for deadlock, and it costs
nothing at runtime.
"""
import threading, time

lock_one = threading.Lock()
lock_two = threading.Lock()

def worker(name):
    print(f"{name}: taking lock 1", flush=True)
    with lock_one:
        time.sleep(0.3)
        print(f"{name}: taking lock 2", flush=True)
        with lock_two:
            print(f"{name}: has both, doing work", flush=True)

a = threading.Thread(target=worker, args=("A",))
b = threading.Thread(target=worker, args=("B",))
a.start(); b.start()
a.join(); b.join()

print()
print("No deadlock. Same locks, same work - only the ORDER changed.")
