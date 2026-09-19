#!/usr/bin/env bash
# Shared assertions and isolation for the test suite.
#
# Two rules the tests here depend on:
#   * A failed assertion must make the script exit non-zero, so a test run
#     can actually gate anything.
#   * A test must never touch the player's real sandbox/ or .catgame_progress.
#     GAME_ROOT drives both of those paths, so make_test_root points it at a
#     throwaway directory before any game module is sourced.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TESTS_PASSED=0
TESTS_FAILED=0
TEST_ROOT=""

# Runs on EXIT. It must re-exit with the status it was entered with: a plain
# trap body ends on rm's success and would report a failing run as a pass.
cleanup_test_root() {
    local status=$?
    if [[ -n "$TEST_ROOT" && -d "$TEST_ROOT" ]]; then
        rm -rf "$TEST_ROOT"
    fi
    exit "$status"
}

# Must be called before sourcing any src/ module: several of them capture
# GAME_ROOT-derived paths at source time.
make_test_root() {
    TEST_ROOT="$(mktemp -d)"
    cp -r "$REPO_ROOT/stages" "$TEST_ROOT/"
    GAME_ROOT="$TEST_ROOT"
    export GAME_ROOT
    trap cleanup_test_root EXIT
}

pass() { TESTS_PASSED=$((TESTS_PASSED + 1)); echo "PASS: $1"; }
fail() { TESTS_FAILED=$((TESTS_FAILED + 1)); echo "FAIL: $1"; }

# assert_ok <description> <command> [args...]
assert_ok() {
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then pass "$desc"; else fail "$desc"; fi
}

# assert_fails <description> <command> [args...]
assert_fails() {
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then fail "$desc"; else pass "$desc"; fi
}

# assert_eq <description> <expected> <actual>
assert_eq() {
    local desc="$1" expected="$2" actual="$3"
    if [[ "$expected" == "$actual" ]]; then
        pass "$desc"
    else
        fail "$desc (expected '$expected', got '$actual')"
    fi
}

assert_path_exists() {
    local desc="$1" path="$2"
    if [[ -e "$path" ]]; then pass "$desc"; else fail "$desc (missing: $path)"; fi
}

# Print the tally and exit non-zero if anything failed.
finish() {
    echo "--- $1: ${TESTS_PASSED} passed, ${TESTS_FAILED} failed"
    if [[ "$TESTS_FAILED" -eq 0 ]]; then
        exit 0
    fi
    exit 1
}
