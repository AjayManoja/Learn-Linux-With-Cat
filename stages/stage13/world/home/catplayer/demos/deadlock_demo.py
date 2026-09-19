#!/usr/bin/env python3
"""Two threads, two locks, acquired in opposite orders. This will hang.

Thread A takes lock 1, then wants lock 2.
Thread B takes lock 2, then wants lock 1.

Neither will ever let go, because each is waiting for the other. That is a
deadlock, and no amount of waiting fixes it.

This script gives up after 5 seconds so you get your prompt back. A real
program would hang forever.
"""
import threading, time, sys

lock_one = threading.Lock()
lock_two = threading.Lock()

def thread_a():
    print("A: taking lock 1", flush=True)
    with lock_one:
        time.sleep(0.3)
        print("A: holding lock 1, now want lock 2 ...", flush=True)
        got = lock_two.acquire(timeout=5)
        if got:
            print("A: got lock 2", flush=True)
            lock_two.release()
        else:
            print("A: gave up waiting for lock 2", flush=True)

def thread_b():
    print("B: taking lock 2", flush=True)
    with lock_two:
        time.sleep(0.3)
        print("B: holding lock 2, now want lock 1 ...", flush=True)
        got = lock_one.acquire(timeout=5)
        if got:
            print("B: got lock 1", flush=True)
            lock_one.release()
        else:
            print("B: gave up waiting for lock 1", flush=True)

a = threading.Thread(target=thread_a)
b = threading.Thread(target=thread_b)
a.start(); b.start()
a.join(); b.join()

print()
print("Both threads sat waiting for a lock the other was holding.")
print("The fix is a lock ORDER: if every thread takes lock 1 before lock 2,")
print("this cannot happen.")
