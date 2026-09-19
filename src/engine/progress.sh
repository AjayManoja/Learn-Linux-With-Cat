#!/usr/bin/env bash
set -euo pipefail

PROGRESS_FILE="${GAME_ROOT:-.}/.catgame_progress"

# Default values
export CURRENT_STAGE=1
export CURRENT_SECTION="A"
export CURRENT_LESSON=""
export COMPLETED_STAGES=""
export PLAYER_NAME="catplayer"
export HINTS_USED=0
export COMMANDS_PRACTICED=""
export STAGE_1_COMPLETED=false

save_progress() {
    cat > "$PROGRESS_FILE" <<EOF
CURRENT_STAGE="${CURRENT_STAGE}"
CURRENT_SECTION="${CURRENT_SECTION}"
CURRENT_LESSON="${CURRENT_LESSON}"
COMPLETED_STAGES="${COMPLETED_STAGES}"
PLAYER_NAME="${PLAYER_NAME}"
HINTS_USED="${HINTS_USED}"
COMMANDS_PRACTICED="${COMMANDS_PRACTICED}"
STAGE_1_COMPLETED="${STAGE_1_COMPLETED}"
EOF
}

load_progress() {
    if [[ -f "$PROGRESS_FILE" ]]; then
        # shellcheck disable=SC1090
        source "$PROGRESS_FILE"
    else
        save_progress
    fi
}

mark_lesson_complete() {
    local lesson_id="$1"
    # Logic to advance lesson could be here, for now just placeholder for tracking
    CURRENT_LESSON="$lesson_id"
    save_progress
}

mark_section_complete() {
    local section="$1"
    CURRENT_SECTION="$section"
    save_progress
}

mark_stage_complete() {
    local stage_num="$1"
    if [[ ! " $COMPLETED_STAGES " =~ \ $stage_num\  ]]; then
        COMPLETED_STAGES="${COMPLETED_STAGES} $stage_num"
        COMPLETED_STAGES="${COMPLETED_STAGES# }" # trim leading space
    fi
    if [[ "$stage_num" == "1" ]]; then
        STAGE_1_COMPLETED=true
    fi
    CURRENT_STAGE=$((stage_num + 1))
    save_progress
}

add_learned_command() {
    local cmd="$1"
    if [[ ! " $COMMANDS_PRACTICED " =~ \ $cmd\  ]]; then
        COMMANDS_PRACTICED="${COMMANDS_PRACTICED} $cmd"
        COMMANDS_PRACTICED="${COMMANDS_PRACTICED# }"
        save_progress
    fi
}

get_learned_commands() {
    echo "$COMMANDS_PRACTICED"
}

increment_hints_used() {
    HINTS_USED=$((HINTS_USED + 1))
    save_progress
}
