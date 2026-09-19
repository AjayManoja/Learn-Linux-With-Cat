#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="File Organization"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="My files are a mess! Can you tidy them up? 🧹
1. Create a folder called 'organized'
2. Copy important.txt into organized/
3. Rename old_notes.txt to archive.txt
4. Delete junk.txt"
MISSION_SUCCESS_MSG="All files are organized perfectly! Great job!"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Four commands, one per step: mkdir, cp, mv, rm."
HINT_2="Copy keeps the original ('cp a b'); rename does not ('mv a b')."
HINT_3="mkdir organized / cp important.txt organized/ / mv old_notes.txt archive.txt / rm junk.txt"

setup_mission() {
    # Lays down important.txt, old_notes.txt and junk.txt with real content.
    build_file_maze
}

check_mission() {
    # Paths here are relative to the sandbox home, which is what every check_*
    # helper resolves against.
    check_dir_exists "organized" \
        && check_file_exists "organized/important.txt" \
        && check_file_exists "archive.txt" \
        && check_file_missing "junk.txt"
}
