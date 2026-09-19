#!/usr/bin/env bash
set -euo pipefail

# 2. filesystem.sh
# Filesystem utilities for populating the game world

populate_stage_files() {
    local stage_number="$1"

    case "$stage_number" in
        1)
            # Generate system.log for the 'less' lesson (08_less.sh)
            generate_system_log "${SANDBOX_HOME}/system.log" 200

            # Inject the secret line somewhere in the middle third
            local secret_pos=$(( (RANDOM % 60) + 70 ))
            inject_secret_line "${SANDBOX_HOME}/system.log" \
                "[2024-03-15 09:15:33] [INFO] Secret door: /home/catplayer/.cat_room" \
                "$secret_pos"

            # Create junk.txt for the 'rm' lesson (13_rm.sh)
            echo "This is just junk data. Nothing useful here." > "${SANDBOX_HOME}/junk.txt"
            echo "Feel free to delete me!" >> "${SANDBOX_HOME}/junk.txt"

            # Create a .bashrc to make 'ls -la' more interesting
            echo "# catplayer's bash configuration" > "${SANDBOX_HOME}/.bashrc"
            echo "# This is a hidden file!" >> "${SANDBOX_HOME}/.bashrc"
            echo "alias ll='ls -la'" >> "${SANDBOX_HOME}/.bashrc"

            # Create a .profile hidden file
            echo "# catplayer's profile" > "${SANDBOX_HOME}/.profile"
            echo "# Login configuration goes here" >> "${SANDBOX_HOME}/.profile"
            ;;
        *)
            # Future stages can add their own population logic
            :
            ;;
    esac
}

inject_secret_line() {
    local filepath="$1"
    local secret_line="$2"
    local position="$3"
    
    if [[ ! -f "${filepath}" ]]; then
        echo "Error: File ${filepath} not found." >&2
        return 1
    fi
    
    # Inject the secret line at the given position
    awk -v pos="${position}" -v line="${secret_line}" 'NR==pos{print line}1' "${filepath}" > "${filepath}.tmp"
    mv "${filepath}.tmp" "${filepath}"
}

generate_system_log() {
    local filepath="$1"
    local num_lines="$2"
    
    mkdir -p "$(dirname "${filepath}")"
    > "${filepath}"
    
    local i
    for (( i=1; i<=num_lines; i++ )); do
        local timestamp="2024-03-15 0$(($RANDOM % 9 + 1)):$((RANDOM % 59 + 10)):$((RANDOM % 59 + 10))"
        local level="INFO"
        local message="Normal system operation"
        
        local rnd=$((RANDOM % 10))
        if (( rnd == 0 )); then
            level="WARN"
            message="Disk usage at $((RANDOM % 30 + 70))%"
        elif (( rnd == 1 )); then
            level="DEBUG"
            message="Checking network interfaces..."
        elif (( rnd == 2 )); then
            message="Backup complete"
        elif (( rnd == 3 )); then
            message="Loading modules..."
        elif (( rnd == 4 )); then
            message="System startup complete"
        fi
        
        echo "[${timestamp}] [${level}] ${message}" >> "${filepath}"
    done
}

create_clue_file() {
    local dirpath="$1"
    local clue_text="$2"
    
    mkdir -p "${dirpath}"
    echo "${clue_text}" > "${dirpath}/clue.txt"
}

verify_structure() {
    local stage_number="$1"
    
    if ! sandbox_exists; then
        return 1
    fi
    
    if [[ ! -d "${SANDBOX_HOME}" ]]; then
        return 1
    fi
    
    return 0
}
