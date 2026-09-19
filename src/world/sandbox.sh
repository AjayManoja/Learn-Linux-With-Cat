#!/usr/bin/env bash
set -euo pipefail

# 1. sandbox.sh
# Sandbox creation and management utilities

SANDBOX_ROOT="${GAME_ROOT}/sandbox"
SANDBOX_HOME="${SANDBOX_ROOT}/home/catplayer"

create_sandbox() {
    local stage_number="$1"
    local template_dir="${GAME_ROOT}/stages/stage${stage_number}/world"
    local player_name="${PLAYER_NAME:-catplayer}"
    
    mkdir -p "${SANDBOX_ROOT}"
    if [[ -d "${template_dir}" ]]; then
        cp -r "${template_dir}/." "${SANDBOX_ROOT}/"
    else
        echo "Error: Template directory ${template_dir} does not exist." >&2
        return 1
    fi
    
    # Replace {{PLAYER}} placeholders with actual player name
    find "${SANDBOX_ROOT}" -type f -exec sed -i "s/{{PLAYER}}/${player_name}/g" {} +
}

destroy_sandbox() {
    if [[ -d "${SANDBOX_ROOT}" ]]; then
        rm -rf "${SANDBOX_ROOT}"
    fi
}

reset_sandbox() {
    local stage_number="$1"
    destroy_sandbox
    create_sandbox "${stage_number}"
}

sandbox_exists() {
    [[ -d "${SANDBOX_ROOT}" ]]
}

get_sandbox_home() {
    echo "${SANDBOX_HOME}"
}
