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
# Which stage's world the sandbox currently holds; see prepare_stage_world.
export SANDBOX_STAGE=""
# Completed work, as "stage<N>:<id>" entries. Keyed by stage so a reset of one
# stage cannot mark another's lessons done.
export COMPLETED_LESSONS=""
export COMPLETED_MISSIONS=""

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
SANDBOX_STAGE="${SANDBOX_STAGE}"
COMPLETED_LESSONS="${COMPLETED_LESSONS}"
COMPLETED_MISSIONS="${COMPLETED_MISSIONS}"
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
    local key="stage${CURRENT_STAGE}:${lesson_id}"

    CURRENT_LESSON="$lesson_id"
    if [[ " $COMPLETED_LESSONS " != *" $key "* ]]; then
        COMPLETED_LESSONS="${COMPLETED_LESSONS} $key"
        COMPLETED_LESSONS="${COMPLETED_LESSONS# }"
    fi
    save_progress
}

lesson_is_complete() {
    [[ " $COMPLETED_LESSONS " == *" stage${CURRENT_STAGE}:${1} "* ]]
}

mark_mission_complete() {
    local mission_id="$1"
    local key="stage${CURRENT_STAGE}:${mission_id}"

    if [[ " $COMPLETED_MISSIONS " != *" $key "* ]]; then
        COMPLETED_MISSIONS="${COMPLETED_MISSIONS} $key"
        COMPLETED_MISSIONS="${COMPLETED_MISSIONS# }"
    fi
    save_progress
}

mission_is_complete() {
    [[ " $COMPLETED_MISSIONS " == *" stage${CURRENT_STAGE}:${1} "* ]]
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
