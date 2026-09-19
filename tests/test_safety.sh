#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/engine/safety.sh"

echo "Testing safety filter..."

# The blocklist is check_safety's whole job: reject commands that would reach
# outside the game, and leave ordinary lesson commands alone.
assert_fails "sudo blocked"          check_safety "sudo rm -rf /"
assert_fails "su blocked"            check_safety "su root"
assert_fails "dd blocked"            check_safety "dd if=/dev/zero of=/dev/sda"
assert_fails "mkfs blocked"          check_safety "mkfs.ext4 /dev/sda1"
assert_fails "shutdown blocked"      check_safety "shutdown -h now"
assert_fails "wget blocked"          check_safety "wget http://example.com"
assert_fails "curl blocked"          check_safety "curl http://example.com"
assert_fails "rm -rf / blocked"      check_safety "rm -rf /"
assert_fails "rm -fr / blocked"      check_safety "rm -fr /"
assert_fails "piped sudo blocked"    check_safety "echo hi | sudo tee /etc/hosts"

assert_ok    "normal rm allowed"     check_safety "rm file.txt"
assert_ok    "ls allowed"            check_safety "ls -la"
assert_ok    "cd allowed"            check_safety "cd Documents"
assert_ok    "cat allowed"           check_safety "cat notes.txt"

# Staying inside the sandbox is enforced by the cd handler, not the blocklist,
# so it has to be exercised where it actually lives.
source "$REPO_ROOT/src/engine/runner.sh"
show_cat() { :; }   # stub: the warning path draws a cat

mkdir -p "$SANDBOX_HOME/Documents"
CURRENT_GAME_DIR="$SANDBOX_HOME"

execute_in_sandbox "cd ../../etc" >/dev/null 2>&1 || true
assert_eq "cd ../../etc cannot escape the sandbox" "$SANDBOX_HOME" "$CURRENT_GAME_DIR"

execute_in_sandbox "cd /etc" >/dev/null 2>&1 || true
assert_eq "cd /etc cannot escape the sandbox" "$SANDBOX_HOME" "$CURRENT_GAME_DIR"

execute_in_sandbox "cd Documents" >/dev/null 2>&1 || true
assert_eq "cd into a real subdirectory works" "$SANDBOX_HOME/Documents" "$CURRENT_GAME_DIR"

execute_in_sandbox "cd .." >/dev/null 2>&1 || true
assert_eq "cd .. back to home works" "$SANDBOX_HOME" "$CURRENT_GAME_DIR"

finish "Safety tests"
