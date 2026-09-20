# 🐱 Learn Linux with Cat

> A terminal game that teaches Linux by doing, not by reading.

---

## 🎯 What Is This?

**Learn Linux with Cat** is an interactive terminal game where a cat teaches you
real Linux commands. Instead of reading tutorials, you type commands into a
sandboxed filesystem and solve missions with them.

Fifteen stages, from `pwd` to explaining why a machine with free RAM is still
slow: **129 lessons, 45 missions, 24 checkpoint challenges and 25
interview questions**. The commands are real, the filesystem is real, `/proc` is the
actual kernel talking, and nothing you type can reach outside the sandbox.

```
   /\_/\
  ( o.o )   Meow! Ready to learn Linux?
   > ^ <
```

---

## 🚀 Quick Start

```bash
git clone https://github.com/AjayManoja/Learn-Linux-With-Cat.git
cd Learn-Linux-With-Cat
chmod +x start.sh
./start.sh
```

**Or with Docker 🐳** — the simplest option on Windows:

```bash
docker build -t catgame .
docker run -it --rm catgame
```

---

## 🔁 How It Works

```
./start.sh → 🐱 Learn ONE command → Practice it → Next command
   → 🧩 Section mission → 🔁 Checkpoint → 🏆 Stage complete → next stage
```

**Two rules the whole game is built on:**

1. Every command is taught, then used immediately.
2. Nothing is taught once. Later stages need earlier commands, and the
   checkpoints exist to make sure none of them have gone stale.

Progress saves after every lesson, so `quit` and come back whenever.

---

## 🗺️ The Stages

Each stage unlocks new commands and reuses everything before it. The sandbox is
rebuilt from that stage's own world when you cross into it, and refuses any
command you have not been taught yet.

| # | Stage | You learn | Final mission |
|---|-------|-----------|---------------|
| 1 | **Welcome to Linux** | `pwd` `ls` `ls -la` `cd` `cat` `less` `mkdir` `touch` `cp` `mv` `rm` | Find the hidden fish toy 🐟 |
| 2 | **Finding Things** | `head` `tail` `wc` `grep` (`-i` `-n` `-r`) `find -name`, the pipe | Identify an intruder in 400 log lines |
| 3 | **Locks and Keys** | `ls -l` `whoami` `id` `stat` `chmod` (numeric + symbolic) `chown` | Open a vault locked at `000` |
| 4 | **Streams and Processes** | `echo` `>` `>>` `sort` `uniq` `ps` `&` `kill` | Build a report with header and tally |
| 5 | **Cat's First Script** | `#!` `chmod +x`, variables, `$1`, `if`, `for` | Write a script using all of it |
| 6 | **Text Surgery** | `cut` `tr` `nl` `sed` (substitute, global, delete) `awk` (fields, conditions) | Filter one column by another |
| 7 | **Finding and Measuring** | `find -type/-size/-mmin/-exec` `xargs` `du` `df` `ln -s` | Count every matching file in bulk |
| 8 | **Archives and Integrity** | `tar` (create, list, extract, compress) `gzip` `diff` `sha256sum` | Ship an archive with a proof |
| 9 | **The Shell Itself** | `env` `export` `PATH` `which` `$?` `&&` `\|\|` `;` `$( )` | Build a one-liner with substitution |
| 10 | **The Toolkit** | `tee` `basename` `mktemp` `exit`, argument guards, `set -euo pipefail` | Write a real tool 🎓 |

### Stages 11–15 — how Linux actually works

The question changes from *what do I type* to *what is happening underneath*.
These stages ship **runnable demos**: you do not read that a race condition
loses updates, you run it and watch the counter come out wrong.

| # | Stage | You learn | You watch it happen |
|---|-------|-----------|---------------------|
| 11 | **How Linux Is Built** | kernel vs shell, user vs kernel space, syscalls, `fork`/`exec`, `/proc` | one process become two, then become a different program |
| 12 | **Processes, Properly** | PID/PPID, process states, orphans, signals, `SIGTERM` vs `SIGKILL`, zombies | a real zombie in state `Z`, and a PPID change to 1 on adoption |
| 13 | **Threads and Races** | process vs thread, shared state, critical sections, mutexes, deadlock, starvation | increments vanish; a lock fixes it; two locks deadlock; a lock *order* fixes that |
| 14 | **Who Gets the CPU** | load average, context switches, time slices, preemption, FCFS/SJF/round robin, `nice` | the same four jobs scheduled three ways, with the waiting times compared |
| 15 | **Where Memory Goes** | virtual vs physical, pages, page faults, swap, page cache, the OOM killer | 256 MB reserved with no RAM used, then 65,536 page faults as it is touched |

**The arc:** *use* Linux (1–10) → *understand* Linux (11–15).

Find your way around → search instead of reading → control who may do what →
send output where you want it → write it down → reshape text → search by what
things *are* → bundle and verify → understand the shell → build tools. Then:
see the layers → follow the processes → break things with concurrency → watch
the scheduler choose → find where the memory went.

---

## 🔁 Review Checkpoints

Commands practised once and never revisited are the ones that go. Every few
stages the game stops teaching and asks questions that **cannot be answered with
the current stage alone**.

| After stage | Checkpoint | Example |
|-------------|------------|---------|
| 3 | Stages 1–3 | Find a file (S2), then read its permissions (S3) |
| 5 | Stages 1–5 | Write a script (S5) that greps (S2) and redirects (S4) |
| 7 | Stages 1–7 | Measure to find the biggest file (S7), then lock it (S3) |
| 10 | Everything | An argument, a guard, a search, a substitution and a redirect |

Each challenge prints the stages it draws on, so you can see why it is being
asked:

```
✅  Find the largest file in hoard/, then lock it to 600.
   Draws on: Stage 7 — du, sort · Stage 3 — chmod
```

Checkpoints are at stages 3, 5, 7, 10 and 15.

---

## 🎓 Interview Questions

Stages 11–15 teach ideas rather than keystrokes, and an idea you cannot put
into words is not learned. Each of those stages ends with **five questions
asked and answered in plain English** — you type a sentence, not a command:

```
❓  QUESTION
What is the difference between a zombie process and an orphan process?

your answer (or 'hint', or 'answer' to reveal): _
```

Matching is deliberately generous — it looks for the words that carry the
meaning, not your phrasing. The model answer is shown either way, because
these double as revision notes. Twenty-five questions in total, covering the
ones that actually get asked: zombie vs orphan, SIGTERM vs SIGKILL, what a page
fault is, why `free` showing no free memory is fine, the four conditions for
deadlock, and what happens between typing `ls` and seeing output.

---

## 🐱 Dynamic Cat Poses

The cat changes expression based on what's happening — 10 distinct poses:

| Situation | Cat |
|-----------|-----|
| Teaching a new command | 😺 Neutral, attentive |
| You complete a task | 😸 Happy, tail up |
| Cat asks a question | 🤔 Thinking, paw on chin |
| Dangerous command! | 🙀 Warning, wide eyes |
| Mission briefing | 🕵️ Detective mode |
| You're idle too long | 😴 Sleeping, zzz |
| Giving a hint | 🤫 Whispering |
| Mission complete! | 🎉 Celebrating |
| Wrong command | 😿 Confused, head tilted |
| Error / deletion | 😢 Sad |

---

## 💡 Hint System

Stuck? Type `hint` for three levels of help:

| Level | Style | Example |
|-------|-------|---------|
| 1️⃣ Nudge | Conceptual | "You need a command that shows what's in a folder." |
| 2️⃣ Reminder | Category | "You know `ls`, but something is hidden." |
| 3️⃣ Answer | Exact | "Try: `ls -la`" |

---

## 🧩 Missions

Every section ends with a mission — no new commands, just a job that needs the
ones you have. Stage 1 finishes with a treasure hunt:

```
🐱 MISSION
Oh no! My fish toy is missing! 🐟
Someone hid it in your filesystem.
Find it using only commands you've learned.
```

- Hidden paths change every run (randomized maze)
- Follow clues through dotfiles and hidden directories
- Find `fish.txt` with a secret code
- Run `./check.sh <CODE>` to win!

Each later stage ends the same way: identify an intruder from 400 log lines,
open a vault you locked yourself out of, ship an archive with a checksum that
proves it, write a tool that refuses bad input. Thirty missions in all.

---

## 🔄 Repetition System

Commands aren't taught once and forgotten. Three things keep them alive:

**Within a stage** — each lesson needs the ones before it:

```
pwd → ls + pwd → cd + pwd → cd + ls + pwd → cd + ls -la + cat → 🧩 Mission uses everything
```

**Across stages** — later stages assume earlier ones. Stage 7 sorts `du` output
with Stage 4's `sort`. Stage 10 wraps Stage 7's `find` in Stage 5's loops.

**At the checkpoints** — questions that deliberately cannot be answered with the
current stage alone. See [Review Checkpoints](#-review-checkpoints) above.

> The player doesn't memorize commands — they get used to them.

---

## 🛡️ Safety

- 🧱 Everything runs in a sandbox directory (never touches your real system)
- 🚧 Every path argument must resolve inside the sandbox — absolute paths and
  `../` escapes are refused
- 🔒 Only commands the current stage has unlocked will run
- ⛓️ Command chaining (`;` `&&` `||`) and substitution (`$( )`) are refused
  until Stage 9 teaches them — until then they are only a way around the
  command gate. Once unlocked, every part of a chained command is still
  checked against what you have been taught
- ☠️ `kill` reaches only processes the game itself started — never your own
  shell or editor
- ♻️ `rm` moves files to Cat's Trash Bin (`.cat_trash`) instead of deleting
  them, so a mistake is recoverable
- 🔓 Locking yourself out is not fatal: Stage 3 encourages you to `chmod`
  things, and the game reopens any directory it needs before staging a mission
- 🔬 Stages 11–15 unlock **read access to `/proc`** so you can inspect the real
  running system. It stays read-only in practice: you are unprivileged, `rm`
  still refuses anything outside the sandbox, and the blocklist is unchanged
- 🚫 Dangerous commands (`rm -rf /`, `sudo`, `wget`, etc.) are blocked
- 🐳 Docker option for full isolation

---

## 🗂️ Project Structure

```
Learn-Linux-With-Cat/
│
├── start.sh              🚀 Entry point
├── reset.sh              ♻️ Reset game
├── check.sh              ✅ Mission code verifier
├── Dockerfile            🐳 Docker sandbox
├── README.md
│
├── src/
│   ├── engine/
│   │   ├── runner.sh     🎮 Game loop (data-driven, stage-agnostic)
│   │   ├── checker.sh    ✅ Task verification library
│   │   ├── progress.sh   💾 Per-player save/load
│   │   ├── cheat.sh      ⏩ cheatcode stage picker
│   │   ├── players.sh    👥 Title screen: new, rename, delete
│   │   ├── hints.sh      💡 3-tier hint system
│   │   ├── history.sh    ↑ Line editing and command recall
│   │   └── safety.sh     🛡️ Command safety filter
│   │
│   ├── ui/
│   │   ├── cat.sh        🐱 Dynamic cat pose system
│   │   ├── colors.sh     🎨 ANSI color definitions
│   │   ├── box.sh        📦 Lesson/mission box renderer
│   │   ├── banner.sh     🏠 Welcome & stage banners
│   │   └── menu.sh       ⌨️  Arrow-key list, shared by both menus
│   │
│   └── world/
│       ├── sandbox.sh    🏗️ Sandbox management
│       ├── maze.sh       🗺️ Randomized path builder
│       └── filesystem.sh 📂 File population utilities
│
├── assets/cat/           🐱 10 ASCII cat poses
│   ├── default.txt       😺 Teaching
│   ├── happy.txt         😸 Success
│   ├── thinking.txt      🤔 Questions
│   ├── warning.txt       🙀 Danger
│   ├── mission.txt       🕵️ Missions
│   ├── sleeping.txt      😴 Idle
│   ├── hint.txt          🤫 Hints
│   ├── celebrate.txt     🎉 Victory
│   ├── confused.txt      😿 Wrong
│   └── sad.txt           😢 Errors
│
├── stages/
│   ├── stage1/  🐾 Welcome to Linux      stage9/   🐚 The Shell Itself
│   ├── stage2/  🔍 Finding Things        stage10/  🧰 The Toolkit
│   ├── stage3/  🔐 Locks and Keys        stage11/  🏗️  How Linux Is Built
│   ├── stage4/  🌊 Streams & Processes   stage12/  👪 Processes, Properly
│   ├── stage5/  📜 Cat's First Script    stage13/  🧵 Threads and Races
│   ├── stage6/  ✂️  Text Surgery          stage14/  ⏱️  Who Gets the CPU
│   ├── stage7/  📏 Finding and Measuring stage15/  🧠 Where Memory Goes
│   └── stage8/  📦 Archives and Integrity
│       ├── stage.conf    📋 Metadata, lesson order, unlocked commands
│       ├── lessons/      📚 Lesson scripts
│       ├── missions/     🧩 Missions
│       ├── review/       🔁 Checkpoint challenges (3, 5, 7, 10, 15)
│       ├── quiz/         🎓 Interview questions (11-15)
│       └── world/        🌍 Filesystem template + runnable demos
│
└── tests/
    ├── run_all.sh        ▶️  Runs everything, exits non-zero on failure
    ├── helpers.sh        🧰 Assertions + isolated GAME_ROOT
    ├── test_engine.sh    💾 Progress save/load
    ├── test_checker.sh   ✅ Task verification library
    ├── test_safety.sh    🛡️ Command gates, sandbox escape, kill gate
    ├── test_missions.sh  🧩 Every mission is actually winnable
    ├── test_lessons.sh   🎯 No lesson passes without doing the task
    ├── test_stage1.sh    🌍 Sandbox build + world population
    └── test_stages.sh    📋 Every stage loads and is complete
```

---

## ⚙️ Architecture: Adding New Stages

The engine is **fully data-driven**. Adding Stage 2 requires **zero engine modifications**:

```
stages/stage6/
├── stage.conf           ← Sections, lessons, missions, STAGE_COMMANDS
├── lessons/*.sh         ← Lesson scripts (same format as every other stage)
├── missions/*.sh        ← Mission scripts
└── world/               ← New filesystem template
    └── home/catplayer/
```

`STAGE_COMMANDS` lists what that stage unlocks. The sandbox refuses anything
the player has not been taught yet, so a command missing from this list will
be rejected even if the lesson teaches it. `STAGE_SYNTAX` does the same for
shell syntax — chaining (`;` `&&` `||`) and command substitution are refused
until Stage 9 declares them, because until then they are only a way around the
command allowlist.

`STAGE_REVIEW` names checkpoint challenges in `review/`. A challenge looks like
a lesson without the teaching: `TASK_INSTRUCTION`, three hints, `check_task`,
plus a `RECALLS` line naming the stages it spans.

`STAGE_QUIZ` names interview questions in `quiz/`. Each defines a `QUESTION`,
an `ANSWER_PATTERN` (a generous regex over the words that carry the meaning)
and a `MODEL_ANSWER`.

`STAGE_SYSTEM_PATHS` unlocks absolute paths outside the sandbox for reading —
`/proc` for the OS stages. Without it every absolute path is refused.

`run_game` walks `stages/stage*/stage.conf` in numeric order and stops at the
first gap, so stages must be numbered contiguously. `tests/test_stages.sh`
checks that for you.

The engine discovers stages via `stages/*/stage.conf`. Stage numbering determines order. Progress tracking handles transitions automatically.

---

## 👥 Players

The title screen is the list of everyone with a save here, newest first, and
how far each of them got:

```
--------------------------------------------------------------
  WHO IS PLAYING?
--------------------------------------------------------------
  up/down move   enter play   n new   r rename   d delete   q quit

->  🐾 Ada Lovelace       Stage 7 · 24 lessons · 2 hours ago
    🐾 catplayer          Stage 1 · 3 lessons · yesterday
    + new adventurer       start a fresh save
--------------------------------------------------------------
```

| Key | What it does |
|-----|--------------|
| ↑ ↓ | Move through the list |
| Enter | Play that save — or start one, on the last row |
| `n` | New adventurer |
| `r` | Rename the selected one; save and command history move with it |
| `d` | Delete the selected one, after a confirmation. There is no undo |
| `q` | Quit without playing |

Each player gets their own save, in `.catgame/<name>.progress`, and their own
command history beside it. Capitalisation and spacing do not matter —
`Ada Lovelace` and `ada_lovelace` are the same adventurer. A save from before
this was per-player (`.catgame_progress`) is handed to the player whose name
is in it the first time they play.

With no terminal to draw on — `docker run` without `-t`, a script piping
input in — the same list is printed with numbers and the rest is typed:
`2`, a name, `rename 2 Ada`, `delete 2`, `quit`.

---

## 💾 Progress

Progress is saved after every lesson, mission and checkpoint challenge, after
every command typed at the prompt, and again on the way out — whether that is
`quit`, Ctrl-C, the terminal window closing, or the machine shutting down
underneath the game. An interrupted session costs you the command you were
typing, not the lesson you were in.

The save is written to a temporary file and renamed over the old one, which
is a single atomic step: a crash in the middle of a save leaves the previous
save whole rather than half of a new one.

| Key | Meaning |
|-----|---------|
| `CURRENT_STAGE` | Stage you are on |
| `COMPLETED_LESSONS` | Finished lessons, as `stage<N>:<id>` |
| `COMPLETED_MISSIONS` | Finished missions |
| `COMMANDS_PRACTICED` | The command each finished lesson taught (`help` shows it) |
| `SANDBOX_STAGE` | Which stage's world the sandbox currently holds |
| `LAST_PLAYED` | When the save was last written — what the title screen orders by |

`./reset.sh` clears the sandbox and every player's progress, and starts over.

---

## 🎮 Game Commands

| Command | What it does |
|---------|-------------|
| `hint` | Get progressive help (3 levels) |
| `help` | Show commands you've learned |
| `progress` | Check your current position |
| `cheatcode` | Jump straight to any stage (see below) |
| `quit` | Save progress and exit |

### ⌨️ At the prompt

The prompt is a real line editor. **↑** and **↓** walk back through the
commands you have already typed, **←**/**→**, Home and End move around the
line, and the usual `Ctrl-A`/`Ctrl-E`/`Ctrl-U` keys work. Your history is
saved with your progress, per player, so last session's commands are still
behind ↑ when you come back.

### ⏩ cheatcode — jump to any stage

Fifteen stages is a long walk to reach the one you are working on. Type
`cheatcode` at any prompt and an arrow-key list of every stage opens:

```
----------------------------------------------------
  CHEAT CODE - jump straight to any stage
----------------------------------------------------
  up/down move    enter jump    q cancel

    5. [✓] Cat's First Script
    6. [ ] Text Surgery   <- you are here
->  7. [ ] Finding and Measuring
    8. [ ] Archives and Integrity
```

Move with the arrow keys (or `j`/`k`), press Enter to jump, `q` to back out.
`[✓]` marks a stage you have finished.

The jump is real, not a fake: the sandbox is rebuilt for the stage you land
on, and every command taught by the stages you skipped is unlocked, so the
new stage's lessons have the vocabulary they are built on. Nothing you did
not play is marked complete — skipped stages stay unticked, and `quit` saves
you where you landed. Picking a stage you have already finished offers to
clear its record so it can be played again.

It exists so a new stage can be tested without replaying the fourteen before
it, but nothing stops a player using it. It is not hidden.

---

## 🧰 Requirements

- **Bash 4+** (Linux, macOS with Homebrew bash, WSL on Windows)
- **python3** for the Stage 11–15 demos (no compiler needed — they are all
  Python, so there is nothing to build)
- `procps` and `psmisc` for `ps` and `pstree`
- Or just **Docker**, which has all of it

> **On Windows:** run it under WSL or Docker, not Git Bash. Stage 3 teaches
> permissions, and Windows mounts ignore `chmod` — a file on `/mnt/c` stays
> `777` whatever you set. The game detects this and relocates its sandbox to a
> native filesystem automatically, so the permission lessons still work, but
> the sandbox will not be in the repo directory. `reset.sh` knows where it went.

---

## 🧪 Running the Tests

```bash
bash tests/run_all.sh          # everything (exits non-zero on any failure)
bash tests/test_lessons.sh     # no lesson passes without doing the task
bash tests/test_missions.sh    # every mission is actually winnable
bash tests/test_stages.sh      # every stage's content is present and loadable
bash tests/test_safety.sh      # sandbox escape, command gates, rm, kill
bash tests/test_checker.sh     # the task-verification library
bash tests/test_engine.sh      # progress save, load and resume
```

Each test file builds a throwaway `GAME_ROOT`, so running the suite never
touches your progress or your sandbox.

Four invariants do most of the work here, because breaking any of them makes
the game *feel* finished when it isn't:

- **No lesson, mission or challenge may pass in a fresh world given an
  unrelated command.** A check that returns success unconditionally prints
  "Well done!" for whatever the player typed and moves on — indistinguishable
  from the game being broken.
- **Every mission must be winnable.** Each one is asserted to start incomplete
  and to finish via the steps its own briefing describes.
- **Every check must run without erroring.** A check that fails to parse
  returns non-zero, which looks exactly like a check correctly rejecting a
  wrong answer — so each one is called and its stderr inspected. `bash -n`
  cannot catch this: an `=~` pattern is only parsed when the line executes.
- **Every setup must survive running twice.** A player who quits partway
  through a mission runs its setup again next session, and mission scripts
  carry their own `set -e`, so a setup that cannot cope with the state it left
  behind takes the whole session down.

---

## 🤝 Contributing

Each stage is a self-contained content package — see
[Adding New Stages](#-architecture-adding-new-stages). Add a directory under
`stages/`, declare it in a `stage.conf`, and the engine picks it up. No engine
changes required.

Before opening a PR, run `bash tests/run_all.sh`. It will tell you if a lesson
can be passed without doing the task, if a mission is unwinnable, if a check
errors instead of rejecting, or if you have left a gap in the stage numbering
that the game would stop at.

---

```
   /\_/\
  ( ^.^ )   Happy learning!
   > ^ <
```
