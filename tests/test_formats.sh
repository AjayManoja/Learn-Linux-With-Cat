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
    grep -q 'head -n 5 diary.txt' <<< "$body"
assert_ok "with what that example does, in plain words" \
    grep -q 'the first 5 lines' <<< "$body"

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
assert_ok "and holds the shape of the command" \
    grep -q 'ls -la \[FOLDER\]' <<< "$rendered"
assert_eq "no format means no box at all" "" "$(show_format_box "")"

# ── An example never hands over the answer ───────────
# The box shows the shape of a command; the task underneath it asks the
# player to use that command on their own files. An example that works on
# the same file the task names is not an example, it is the answer, and a
# player who copies it has been taught nothing. So: no example may reuse a
# word from its own lesson's task or hints.

strip_colour() { sed 's/\[[0-9;]*m//g'; }

# The shape is everything before the blank line, the examples everything
# after it. The example sits in the first 34 columns of its line.
format_part() {
    local key="$1" want="$2" seen_gap=false line text
    while IFS= read -r line; do
        if [[ -z "${line// /}" ]]; then seen_gap=true; continue; fi
        if [[ "$want" == "shape" ]]; then
            $seen_gap && continue
            printf '%s
' "$line"
            continue
        fi
        $seen_gap || continue
        text="${line:2:34}"
        text="${text%"${text##*[![:space:]]}"}"
        [[ -n "$text" ]] && printf '%s
' "$text"
    done < <(command_format_lines "$key" | strip_colour)
}

unfair=""
checked=0
while IFS= read -r lesson; do
    key="$(
        line="$(grep -m1 '^LESSON_COMMAND=' "$lesson")" || true
        eval "$line" 2>/dev/null
        printf '%s' "${LESSON_COMMAND:-}"
    )"
    [[ -n "$key" ]] || continue

    # What the lesson asks for, and every hint it gives towards it.
    task="$(grep -E '^(TASK_INSTRUCTION|HINT_1|HINT_2|HINT_3)=' "$lesson" | tr -s '[:space:]' ' ')"
    shape="$(format_part "$key" shape)"

    while IFS= read -r example; do
        [[ -n "$example" ]] || continue
        first="${example%% *}"
        for token in $example; do
            # The command being taught and its own syntax are not giveaways:
            # they are what the lesson is about, and they are in the shape
            # line above. Only the arguments can hand over the answer.
            [[ "$token" == "$first" ]] && continue
            [[ "$token" == -* ]] && continue
            [[ "$token" == '$'* ]] && continue
            [[ "${#token}" -ge 3 ]] || continue
            [[ "$token" =~ [A-Za-z] ]] || continue
            case "$token" in do|then|done|fi|in) continue ;; esac

            token="$(printf '%s' "$token" | tr -d "\"'")"
            grep -qF -- "$token" <<< "$shape" && continue

            if grep -qF -- "$token" <<< "$task"; then
                unfair="${unfair}
  ${key}: '${example}' reuses '${token}' from the task"
            fi
        done
        checked=$((checked + 1))
    done < <(format_part "$key" example)
done < <(find "$REPO_ROOT/stages" -path '*/lessons/*.sh' | sort)

assert_eq "no example reuses anything the lesson's own task asks for" "" "$unfair"
assert_ok "and there were plenty of examples to check" test "$checked" -ge 100

# ── A lesson can write its own ─────────────────────────────

LESSON_COMMAND="ls"
LESSON_FORMAT="ls --brand-new-flag FILE"
assert_ok "a lesson's own format wins over the table" \
    grep -q -- '--brand-new-flag' <<< "$(lesson_format_body)"

LESSON_FORMAT=""
assert_ok "and without one the table is used" \
    grep -q 'ls \[OPTIONS\]' <<< "$(lesson_format_body)"

finish "Command format tests"
