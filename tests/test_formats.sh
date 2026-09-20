#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/ui/colors.sh"
source "$REPO_ROOT/src/ui/box.sh"
source "$REPO_ROOT/src/engine/formats.sh"

echo "Testing command formats..."

# ── The shape of an entry ──────────────────────────────────

body="$(command_format_lines "head")"
assert_eq "the shape comes first, with the parts to fill in capitalised" \
    "head [-n NUMBER] FILE" "$(sed -n '1p' <<< "$body" | sed 's/^ *//')"
assert_ok "and a worked example follows it" \
    grep -q 'head -n 3 notes.txt' <<< "$body"
assert_ok "with what that example does, in plain words" \
    grep -q 'the first 3 lines' <<< "$body"

# A lesson about an idea has no command to write out, and gets no box.
assert_eq "a lesson about a concept has no format" "" "$(command_format_lines "deadlock")"
assert_eq "and neither does a lesson that names no command" "" "$(command_format_lines "")"

# ── Every command the game teaches has one ─────────────────
# This is the assertion that matters: a new lesson without a format is a
# lesson whose explanation stops short of saying what to type.

# The lessons that teach an idea rather than a command. Listed rather than
# guessed at, so a real command added without a format still fails.
concept_lessons() {
    cat <<'CONCEPTS'
syscall
fork/exec
orphan
zombie
threads
race
critical section
mutex
deadlock
lock ordering
context switch
time slice
preemption
round robin
FCFS
SJF
virtual memory
pages
page fault
swap
buff/cache
OOM
CONCEPTS
}

is_concept() {
    concept_lessons | grep -qxF -- "$1"
}

missing=""
covered=0
while IFS= read -r lesson; do
    # Read the assignment alone rather than sourcing: a lesson file defines
    # functions that would land in this shell.
    command_taught="$(
        line="$(grep -m1 '^LESSON_COMMAND=' "$lesson")" || true
        eval "$line" 2>/dev/null
        printf '%s' "${LESSON_COMMAND:-}"
    )"

    [[ -n "$command_taught" ]] || continue
    is_concept "$command_taught" && continue

    if [[ -z "$(command_format_lines "$command_taught")" ]]; then
        missing="${missing} ${command_taught}"
    else
        covered=$((covered + 1))
    fi
done < <(find "$REPO_ROOT/stages" -path '*/lessons/*.sh' | sort)

assert_eq "every command a lesson teaches has a format" "" "${missing# }"
assert_ok "and there are as many of them as there are lessons" \
    test "$covered" -ge 100

# ── The box ────────────────────────────────────────────────

rendered="$(show_format_box "$(command_format_lines "ls -la")")"
assert_ok "the box is titled so a beginner knows what it is for" \
    grep -q 'HOW TO WRITE IT' <<< "$rendered"
assert_ok "and explains its own notation" \
    grep -q 'CAPITALS' <<< "$rendered"

# A shape with nothing to fill in explains nothing: "pwd" is the whole of it.
rendered="$(show_format_box "$(command_format_lines "pwd")")"
assert_fails "a command with no parts to fill in skips the notation line" \
    grep -q 'CAPITALS' <<< "$rendered"

assert_eq "no format means no box at all" "" "$(show_format_box "")"

# ── A lesson can write its own ─────────────────────────────

LESSON_COMMAND="ls"
LESSON_FORMAT="ls --brand-new-flag FILE"
assert_ok "a lesson's own format wins over the table" \
    grep -q -- '--brand-new-flag' <<< "$(lesson_format_body)"

LESSON_FORMAT=""
assert_ok "and without one the table is used" \
    grep -q 'ls \[OPTIONS\]' <<< "$(lesson_format_body)"

finish "Command format tests"
