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
        2)
            # Stage 2 is about searching rather than reading, so its files are
            # deliberately too long to page through.
            generate_system_log "${SANDBOX_HOME}/logs/system.log" 400
            generate_system_log "${SANDBOX_HOME}/logs/archive.log" 250

            inject_secret_line "${SANDBOX_HOME}/logs/system.log"                 "[2024-03-15 03:14:15] [ERROR] Intruder detected: dog at the cat flap"                 $(( (RANDOM % 200) + 100 ))
            inject_secret_line "${SANDBOX_HOME}/logs/system.log"                 "[2024-03-15 03:14:16] [ERROR] Cat flap lock code: ${RANDOM}${RANDOM}"                 $(( (RANDOM % 80) + 300 ))
            ;;
        3)
            # Stage 3 is about permissions, so the world ships deliberate modes.
            mkdir -p "${SANDBOX_HOME}/work" "${SANDBOX_HOME}/vault"

            cat > "${SANDBOX_HOME}/work/secrets.txt" <<'SECRETS'
The humans think the vacuum cleaner is theirs.
It is not. We are merely tolerating it.
SECRETS

            cat > "${SANDBOX_HOME}/work/greet.sh" <<'GREET'
#!/usr/bin/env bash
echo "Meow! This file can only run once you give it the execute bit."
GREET

            cat > "${SANDBOX_HOME}/work/backup.sh" <<'BACKUP'
#!/usr/bin/env bash
echo "Backing up all nap locations..."
BACKUP

            # Deliberately wrong to begin with; the lessons and missions fix them.
            chmod 644 "${SANDBOX_HOME}/work/report.txt"  2>/dev/null || true
            chmod 644 "${SANDBOX_HOME}/work/draft.txt"   2>/dev/null || true
            chmod 666 "${SANDBOX_HOME}/work/secrets.txt" 2>/dev/null || true
            chmod 644 "${SANDBOX_HOME}/work/greet.sh"    2>/dev/null || true
            chmod 644 "${SANDBOX_HOME}/work/backup.sh"   2>/dev/null || true
            ;;
        4)
            mkdir -p "${SANDBOX_HOME}/data"
            ;;
        5)
            # Stage 5 writes its own files; it only needs somewhere to put them.
            mkdir -p "${SANDBOX_HOME}/scripts"
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
        # Minutes and seconds were "% 59 + 10", which produced values up to 68
        # — timestamps like 02:63:65 in a file the player is being taught to
        # read as a real log.
        local timestamp
        timestamp=$(printf '2024-03-15 %02d:%02d:%02d'             "$((RANDOM % 24))" "$((RANDOM % 60))" "$((RANDOM % 60))")
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
