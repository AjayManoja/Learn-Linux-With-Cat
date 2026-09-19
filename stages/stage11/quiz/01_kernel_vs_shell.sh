#!/usr/bin/env bash
QUESTION="What is the difference between the kernel and the shell?"
QUESTION_HINT="One of them owns the hardware. The other is a program you could uninstall."
ANSWER_PATTERN="kernel.*(hardware|manage|control|core|own)|shell.*(program|interface|command|interpret)"
MODEL_ANSWER="The kernel is the core of the operating system. It owns the hardware,
manages memory and processes, and is the only thing allowed to touch devices
directly. There is exactly one, and it is always running.

The shell is an ordinary user-space program that reads what you type and asks
the kernel to run it. You can swap bash for zsh, or delete it entirely, and the
kernel neither notices nor cares.

Short version: the kernel IS the operating system; the shell is how you talk to it."
