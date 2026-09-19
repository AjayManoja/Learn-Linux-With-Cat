#!/usr/bin/env bash
set -euo pipefail

# 1. sandbox.sh
# Sandbox creation and management utilities

# Stage 3 teaches permissions, which needs a filesystem that honours chmod.
# Windows mounts do not: under WSL a file on /mnt/c stays 777 no matter what
# chmod says, so every permission lesson would be unwinnable. Detect that and
# move the sandbox somewhere that works.
filesystem_honours_chmod() {
    local dir="$1" probe rc=1
    mkdir -p "$dir" 2>/dev/null || return 1
    probe="$(mktemp "${dir}/.chmod_probe.XXXXXX" 2>/dev/null)" || return 1
    chmod 600 "$probe" 2>/dev/null || true
    [[ "$(stat -c %a "$probe" 2>/dev/null)" == "600" ]] && rc=0
    rm -f "$probe"
    return "$rc"
}

resolve_sandbox_root() {
    local preferred="${GAME_ROOT}/sandbox"

    if filesystem_honours_chmod "${GAME_ROOT}"; then
        echo "$preferred"
        return 0
    fi

    # Fall back to a native filesystem, keyed by the game directory so two
    # checkouts do not fight over one sandbox.
    local key
    key="$(echo "${GAME_ROOT}" | tr -c 'A-Za-z0-9' '_' | tail -c 40)"
    echo "${TMPDIR:-/tmp}/learn-linux-with-cat${key}/sandbox"
}

SANDBOX_ROOT="${SANDBOX_ROOT:-$(resolve_sandbox_root)}"
SANDBOX_HOME="${SANDBOX_ROOT}/home/catplayer"
export SANDBOX_ROOT SANDBOX_HOME

# Where the sandbox ended up, for reset.sh and for telling the player.
sandbox_location() {
    echo "$SANDBOX_ROOT"
}

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
