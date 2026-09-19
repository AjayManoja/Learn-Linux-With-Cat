#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="File Organization"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Cat's files are disorganized. Player must:
1. Create a folder called 'organized'
2. Copy important.txt into organized/
3. Rename old_notes.txt to archive.txt
4. Delete junk.txt"
MISSION_SUCCESS_MSG="All files are organized perfectly! Great job!"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Use 'mkdir' to create the folder."
HINT_2="Use 'cp' to copy, 'mv' to rename, and 'rm' to delete."
HINT_3="Remember to target the exact filenames mentioned."

setup_mission() {
    local home_dir="$GAME_ROOT/sandbox/home/catplayer"
    touch "$home_dir/important.txt"
    touch "$home_dir/old_notes.txt"
    touch "$home_dir/junk.txt"
}

check_mission() {
    local home_dir="$GAME_ROOT/sandbox/home/catplayer"
    check_dir_exists "$home_dir/organized" && \
    check_file_exists "$home_dir/organized/important.txt" && \
    check_file_exists "$home_dir/archive.txt" && \
    ! check_file_exists "$home_dir/junk.txt"
}
