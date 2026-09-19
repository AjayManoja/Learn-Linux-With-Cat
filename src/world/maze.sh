#!/usr/bin/env bash
set -euo pipefail

# 3. maze.sh
# Randomized maze/path builder for missions

build_nav_maze() {
    local base_dir="${SANDBOX_HOME}"
    local spots=("Documents/.hidden_notes" "Downloads/.archive" "Pictures/.metadata" "projects/.drafts")
    
    # Pick a random spot. NAV_NOTE_DIR is global on purpose: nav_mission reads
    # it to check the player's location and to write its final hint.
    local rand_index=$(( RANDOM % ${#spots[@]} ))
    NAV_NOTE_DIR="${spots[$rand_index]}"
    local target_dir="${base_dir}/${NAV_NOTE_DIR}"
    
    mkdir -p "${target_dir}"
    
    # Generate 6-char code
    MAZE_CODE=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 6 || true)
    
    echo "Congratulations! You found the hidden note." > "${target_dir}/note.txt"
    echo "Your mission code is: ${MAZE_CODE}" >> "${target_dir}/note.txt"
}

build_file_maze() {
    local base_dir="${SANDBOX_HOME}"
    
    echo "This is important stuff. Don't lose it." > "${base_dir}/important.txt"
    echo "Just some old notes about mice." > "${base_dir}/old_notes.txt"
    echo "Trash data, totally useless." > "${base_dir}/junk.txt"
    
    # Expectations could be set here if needed by the task
    
    MAZE_CODE=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 6 || true)
}

build_hidden_cat_maze() {
    local base_dir="${SANDBOX_HOME}"
    
    local clue_spots=(".notes" ".hints" ".secrets" "Documents/.old" "Downloads/.hidden")
    local inter_spots=("projects/.backup" "Documents/school/.extra" "Pictures/.raw")
    local final_spots=("projects/.secret" "Downloads/.treasure" ".cat_room")
    
    local clue_spot="${clue_spots[$((RANDOM % ${#clue_spots[@]}))]}"
    local inter_spot="${inter_spots[$((RANDOM % ${#inter_spots[@]}))]}"
    local final_spot="${final_spots[$((RANDOM % ${#final_spots[@]}))]}"
    
    mkdir -p "${base_dir}/${clue_spot}"
    mkdir -p "${base_dir}/${inter_spot}"
    mkdir -p "${base_dir}/${final_spot}"
    
    # Clue 1 leads to Intermediate
    if [[ "${inter_spot}" == *"projects"* ]]; then
        echo "Where the projects sleep..." > "${base_dir}/${clue_spot}/clue.txt"
    elif [[ "${inter_spot}" == *"school"* ]]; then
        echo "Look where extra school work hides..." > "${base_dir}/${clue_spot}/clue.txt"
    else
        echo "Look where pictures hide their secrets..." > "${base_dir}/${clue_spot}/clue.txt"
    fi
    
    # Clue 2 (Intermediate) leads to Final
    if [[ "${final_spot}" == *".cat_room"* ]]; then
        echo "The cat's personal sanctuary..." > "${base_dir}/${inter_spot}/clue.txt"
    elif [[ "${final_spot}" == *"treasure"* ]]; then
        echo "X marks the spot in downloads..." > "${base_dir}/${inter_spot}/clue.txt"
    else
        echo "The most guarded project of all..." > "${base_dir}/${inter_spot}/clue.txt"
    fi
    
    # Final spot has fish.txt and code
    local final_code
    final_code=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 6 || true)
    
    # Global: hidden_cat_mission checks the player actually reached this spot.
    HIDDEN_FISH_DIR="${final_spot}"

    echo "You found the fish! 🐟" > "${base_dir}/${final_spot}/fish.txt"
    echo "Your final mission code is: ${final_code}" >> "${base_dir}/${final_spot}/fish.txt"
    
    echo "${final_code}" > "${GAME_ROOT}/.mission_code"
}
