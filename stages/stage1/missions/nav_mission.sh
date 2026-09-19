#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Navigation Mastery"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I've lost one of my notes somewhere in my home folder! 📝
It's tucked away in a directory that a plain 'ls' won't show you.
Track it down using only what you've learned: pwd, ls, ls -la and cd.
Stand in the folder that holds the note and I'll know you found it."
MISSION_SUCCESS_MSG="You found the missing note! Excellent navigation skills!"
MISSION_SUCCESS_POSE="celebrate"

# Placeholders only. The note's location is randomized by build_nav_maze, so
# the real hints are written in setup_mission once that location is known.
HINT_1="Hidden directories start with a dot."
HINT_2="Look inside each folder in your home directory."
HINT_3="Use 'ls -la' to reveal what's hidden."

setup_mission() {
    build_nav_maze

    # run_mission calls set_hints before setup_mission, so this overrides those
    # placeholders now that NAV_NOTE_DIR exists.
    set_hints \
        "A plain 'ls' hides anything starting with a dot. There's a command flag for that." \
        "Work through the folders in your home one at a time: cd in, run 'ls -la', then cd .. back out." \
        "The note is in ${NAV_NOTE_DIR}. Try: cd ${NAV_NOTE_DIR}"
}

check_mission() {
    # Completed by navigating into the directory holding note.txt. Section A has
    # only taught pwd, ls, ls -la and cd, so the check has to be reachable with
    # those alone — reading the file is not yet possible.
    check_current_dir "${NAV_NOTE_DIR}" && check_file_exists "${NAV_NOTE_DIR}/note.txt"
}
