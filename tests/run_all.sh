#!/usr/bin/env bash
# Runs every test file and exits non-zero if any of them failed.
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
failed=0

for test_file in "$TESTS_DIR"/test_*.sh; do
    echo "=============================================="
    echo "  $(basename "$test_file")"
    echo "=============================================="
    if bash "$test_file"; then
        echo ""
    else
        failed=$((failed + 1))
        echo ""
    fi
done

echo "=============================================="
if [[ "$failed" -eq 0 ]]; then
    echo "  All test files passed."
else
    echo "  $failed test file(s) failed."
fi
echo "=============================================="

[[ "$failed" -eq 0 ]]
