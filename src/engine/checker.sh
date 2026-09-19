#!/usr/bin/env bash
set -euo pipefail

CHECK_RESULT_MSG=""
SANDBOX_HOME="${GAME_ROOT:-.}/sandbox/home/catplayer"

check_command_output() {
    local cmd="$1"
    local expected="$2"
    local actual
    
    # Running securely in sandbox context is expected
    # Here we just eval in current context (caller should set CWD)
    actual=$(eval "$cmd" 2>&1 || true)
    
    if [[ "$actual" == *"$expected"* ]]; then
        CHECK_RESULT_MSG="Command output matches expected."
        return 0
    else
        CHECK_RESULT_MSG="Command output did not match. Expected to contain: $expected"
        return 1
    fi
}

check_file_exists() {
    local filepath="${SANDBOX_HOME}/$1"
    if [[ -f "$filepath" ]]; then
        CHECK_RESULT_MSG="File exists: $1"
        return 0
    else
        CHECK_RESULT_MSG="File not found: $1"
        return 1
    fi
}

check_dir_exists() {
    local dirpath="${SANDBOX_HOME}/$1"
    if [[ -d "$dirpath" ]]; then
        CHECK_RESULT_MSG="Directory exists: $1"
        return 0
    else
        CHECK_RESULT_MSG="Directory not found: $1"
        return 1
    fi
}

check_file_missing() {
    local filepath="${SANDBOX_HOME}/$1"
    if [[ ! -e "$filepath" ]]; then
        CHECK_RESULT_MSG="File is missing as expected: $1"
        return 0
    else
        CHECK_RESULT_MSG="File still exists: $1"
        return 1
    fi
}

check_file_content() {
    local filepath="${SANDBOX_HOME}/$1"
    local expected="$2"
    
    if [[ ! -f "$filepath" ]]; then
        CHECK_RESULT_MSG="File not found: $1"
        return 1
    fi
    
    if grep -qF "$expected" "$filepath"; then
        CHECK_RESULT_MSG="File contains expected content."
        return 0
    else
        CHECK_RESULT_MSG="File does not contain expected content."
        return 1
    fi
}

check_file_copied() {
    local src="$1"
    local dest="$2"
    
    if check_file_exists "$src" && check_file_exists "$dest"; then
        CHECK_RESULT_MSG="File successfully copied from $src to $dest."
        return 0
    else
        CHECK_RESULT_MSG="Copy failed or files missing."
        return 1
    fi
}

check_current_dir() {
    local expected="$1"
    if [[ "$CURRENT_GAME_DIR" == "$expected" || "$CURRENT_GAME_DIR" == "${SANDBOX_HOME}/${expected}" ]]; then
        CHECK_RESULT_MSG="Current directory is $expected."
        return 0
    else
        CHECK_RESULT_MSG="Current directory is not $expected."
        return 1
    fi
}

check_file_moved() {
    local src="$1"
    local dest="$2"
    
    if check_file_missing "$src" && check_file_exists "$dest"; then
        CHECK_RESULT_MSG="File successfully moved from $src to $dest."
        return 0
    else
        CHECK_RESULT_MSG="Move failed: Source might still exist or destination missing."
        return 1
    fi
}
