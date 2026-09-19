# 🐱 Learn Linux with Cat

> A terminal game that teaches Linux by doing, not by reading.

---

## 🎯 What Is This?

**Learn Linux with Cat** is an interactive terminal game where a cat teaches you
real Linux commands. Instead of reading tutorials, you type commands into a
sandboxed filesystem and solve missions with them.

Ten stages, from `pwd` to writing your own tools: **91 lessons, 30 missions and
4 review checkpoints**. The commands are real, the filesystem is real, and
nothing you type can reach anything outside the sandbox.

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

## 🗺️ The Ten Stages

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

**The arc:** find your way around → search instead of reading → control who may
do what → send output where you want it → write it down → reshape text → search
by what things *are* → bundle and verify → understand the shell itself → build
tools out of all of it.

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
├── LICENSE
│
├── src/
│   ├── engine/
│   │   ├── runner.sh     🎮 Game loop (data-driven, stage-agnostic)
│   │   ├── checker.sh    ✅ Task verification library
│   │   ├── progress.sh   💾 Save/load progress
│   │   ├── hints.sh      💡 3-tier hint system
│   │   └── safety.sh     🛡️ Command safety filter
│   │
│   ├── ui/
│   │   ├── cat.sh        🐱 Dynamic cat pose system
│   │   ├── colors.sh     🎨 ANSI color definitions
│   │   ├── box.sh        📦 Lesson/mission box renderer
│   │   └── banner.sh     🏠 Welcome & stage banners
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
│   ├── stage1/  🐾 Welcome to Linux      stage6/  ✂️  Text Surgery
│   ├── stage2/  🔍 Finding Things        stage7/  📏 Finding and Measuring
│   ├── stage3/  🔐 Locks and Keys        stage8/  📦 Archives and Integrity
│   ├── stage4/  🌊 Streams & Processes   stage9/  🐚 The Shell Itself
│   └── stage5/  📜 Cat's First Script    stage10/ 🧰 The Toolkit
│       ├── stage.conf    📋 Metadata, lesson order, unlocked commands
│       ├── lessons/      📚 Lesson scripts
│       ├── missions/     🧩 Missions
│       ├── review/       🔁 Checkpoint challenges (stages 3, 5, 7, 10)
│       └── world/        🌍 Filesystem template
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

`run_game` walks `stages/stage*/stage.conf` in numeric order and stops at the
first gap, so stages must be numbered contiguously. `tests/test_stages.sh`
checks that for you.

The engine discovers stages via `stages/*/stage.conf`. Stage numbering determines order. Progress tracking handles transitions automatically.

---

## 💾 Progress

Progress is saved to `.catgame_progress` after every lesson, mission and
checkpoint challenge. Quit with `quit` and the next session picks up at the
next unfinished item rather than replaying the stage.

| Key | Meaning |
|-----|---------|
| `CURRENT_STAGE` | Stage you are on |
| `COMPLETED_LESSONS` | Finished lessons, as `stage<N>:<id>` |
| `COMPLETED_MISSIONS` | Finished missions |
| `COMMANDS_PRACTICED` | Everything you have typed at least once (`help` shows it) |
| `SANDBOX_STAGE` | Which stage's world the sandbox currently holds |

`./reset.sh` clears progress and the sandbox and starts you over.

---

## 🎮 Game Commands

| Command | What it does |
|---------|-------------|
| `hint` | Get progressive help (3 levels) |
| `help` | Show commands you've learned |
| `progress` | Check your current position |
| `quit` | Save progress and exit |

---

## 🧰 Requirements

- **Bash 4+** (Linux, macOS with Homebrew bash, WSL on Windows)
- No external dependencies
- Or just **Docker**

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

## 📜 License

MIT License — see [LICENSE](LICENSE)

---

```
   /\_/\
  ( ^.^ )   Happy learning!
   > ^ <
```
