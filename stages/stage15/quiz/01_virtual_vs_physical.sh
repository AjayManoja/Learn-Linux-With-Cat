#!/usr/bin/env bash
QUESTION="What is the difference between a virtual address and a physical address?"
QUESTION_HINT="One is what your program says. The other is where the data really is."
ANSWER_PATTERN="(virtual.*(translat|map|process|not real))|(physical.*(real|actual|ram|hardware|chip))|page table|mmu"
MODEL_ANSWER="A virtual address is what a program uses. Every process has its own virtual
address space, and they all start at zero - two processes can both use address
0x1000 and mean completely different memory.

A physical address is the real location in RAM. The CPU's MMU translates virtual to
physical on every single access, using a per-process page table, with recent
translations cached in the TLB.

This buys three things: isolation, because a process cannot name memory outside its
own mappings; flexibility, because physically scattered frames can look contiguous;
and overcommit, because a page needs no physical frame until it is touched."
