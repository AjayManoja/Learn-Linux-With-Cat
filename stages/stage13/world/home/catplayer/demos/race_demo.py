#!/usr/bin/env python3
"""Four threads each add 1 to a shared counter, 2000 times.

Expected: 8000. You will not get 8000.

The line `counter = tmp + 1` is not one operation. It is three:
    read counter into tmp
    add 1
    write the result back
If the scheduler switches threads between the read and the write, two
threads both read the same value, both add 1, and both write back the same
result. One increment vanishes.
"""
import threading, time

counter = 0
PER_THREAD = 2000
THREADS = 4

def worker():
    global counter
    for _ in range(PER_THREAD):
        tmp = counter       # read
        time.sleep(0)       # the scheduler may switch right here
        counter = tmp + 1   # write

threads = [threading.Thread(target=worker) for _ in range(THREADS)]
for t in threads:
    t.start()
for t in threads:
    t.join()

expected = PER_THREAD * THREADS
print(f"expected : {expected}")
print(f"actual   : {counter}")
print(f"lost     : {expected - counter} increments")
print()
print("Nothing crashed. No error was raised. The answer is simply wrong,")
print("and it will be wrong by a different amount every time you run it.")
