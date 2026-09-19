#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$GAME_ROOT/src/engine/safety.sh"

echo "Testing safety filter..."

if ! validate_command "sudo rm -rf /" >/dev/null 2>&1; then
    echo "PASS: sudo blocked"
else
    echo "FAIL: sudo not blocked"
fi

if ! validate_command "rm -rf /" >/dev/null 2>&1; then
    echo "PASS: rm -rf / blocked"
else
    echo "FAIL: rm -rf / not blocked"
fi

if validate_command "rm file.txt" >/dev/null 2>&1; then
    echo "PASS: normal rm allowed"
else
    echo "FAIL: normal rm not allowed"
fi

if ! validate_command "cd ../../etc" >/dev/null 2>&1; then
    echo "PASS: path traversal blocked"
else
    echo "FAIL: path traversal not blocked"
fi

echo "Safety tests complete."
