#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Journey of One ls"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Write it down.
Create journey.txt describing what happens when you type ls, in order.
Your file must mention all five of these somewhere in it:
  fork - exec - syscall - kernel - PATH
One line each is plenty. You are explaining it to yourself in six months."
MISSION_SUCCESS_MSG="Fork, exec, PATH lookup, syscall, kernel. That sequence answers half the questions in a Linux interview."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Five words, in the order the events actually happen."
HINT_2="The shell forks; the copy execs; PATH found the file; ls makes syscalls; the kernel serves them."
HINT_3="Start with: echo shell calls fork > journey.txt   then append the rest with >>"

setup_mission() {
    rm -f "${SANDBOX_HOME}/journey.txt"
}

check_mission() {
    check_file_exists "journey.txt" \
        && check_file_matches "journey.txt" '[Ff]ork' \
        && check_file_matches "journey.txt" '[Ee]xec' \
        && check_file_matches "journey.txt" '[Ss]yscall|[Ss]ystem call' \
        && check_file_matches "journey.txt" '[Kk]ernel' \
        && check_file_matches "journey.txt" '[Pp][Aa][Tt][Hh]'
}
