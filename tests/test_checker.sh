#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$GAME_ROOT/src/engine/checker.sh"

echo "Testing checker..."

test_dir="/tmp/cat_test_$$"
mkdir -p "$test_dir"
touch "$test_dir/test_file.txt"

if check_file_exists "$test_dir/test_file.txt" >/dev/null 2>&1; then
    echo "PASS: check_file_exists found file"
else
    echo "FAIL: check_file_exists did not find file"
fi

if ! check_file_exists "$test_dir/missing_file.txt" >/dev/null 2>&1; then
    echo "PASS: check_file_exists handled missing file correctly"
else
    echo "FAIL: check_file_exists failed on missing file"
fi

rm -rf "$test_dir"

echo "Checker tests complete."
