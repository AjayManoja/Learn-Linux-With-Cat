#!/usr/bin/env bash
set -euo pipefail

SANDBOX_HOME="${GAME_ROOT:-.}/sandbox/home/catplayer"
TRASH_DIR="$SANDBOX_HOME/.cat_trash"

init_safety() {
    mkdir -p "$TRASH_DIR"
}

check_safety() {
    local cmd_string="$1"
    
    # Block dangerous commands
    local blocked_commands=("sudo" "su" "chmod 777" "dd" "mkfs" "shutdown" "reboot" "halt" "poweroff" "wget" "curl")
    
    for blocked in "${blocked_commands[@]}"; do
        if [[ "$cmd_string" == "$blocked"* || "$cmd_string" == *" $blocked "* ]]; then
            echo "Blocked command: $blocked"
            return 1
        fi
    done
    
    # Block rm -rf /
    if [[ "$cmd_string" == *"rm -rf /"* || "$cmd_string" == *"rm -fr /"* ]]; then
        echo "Blocked command: rm -rf /"
        return 1
    fi
    
    return 0
}

safe_rm() {
    local target="$1"
    local full_path="${SANDBOX_HOME}/${target}"
    
    if [[ -e "$full_path" ]]; then
        mv "$full_path" "$TRASH_DIR/"
    else
        echo "rm: cannot remove '$target': No such file or directory"
        return 1
    fi
}

safe_execute() {
    local cmd="$1"
    
    if ! check_safety "$cmd"; then
        if command -v show_cat >/dev/null; then
            show_cat "warning" "Meow! That command is dangerous and blocked in the sandbox!"
        else
            echo "[WARNING] Command blocked by safety filter."
        fi
        return 1
    fi
    
    # Execute (usually handled properly in runner.sh, this is a basic wrapper)
    eval "$cmd"
}
