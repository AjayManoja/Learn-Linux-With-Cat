# 🐱 Learn Linux with Cat

> A terminal game that teaches Linux by doing, not by reading.

---

## 🎯 What Is This?

**Learn Linux with Cat** is an interactive terminal game where a friendly cat character guides you through real Linux commands. Instead of reading tutorials, you learn by typing commands, exploring a virtual filesystem, and solving missions.

```
   /\_/\
  ( o.o )   Meow! Ready to learn Linux?
   > ^ <
```

---

## 🚀 Quick Start

```bash
git clone https://github.com/<you>/learn-linux-with-cat.git
cd learn-linux-with-cat
chmod +x start.sh
./start.sh
```

**Or with Docker 🐳**

```bash
docker build -t catgame .
docker run -it catgame
```

---

## 🔁 How It Works

```
Clone repo → ./start.sh → 🐱 Cat appears → Learn ONE command
   → Practice it → Next command → 🧩 Hidden mission → 🏆 Stage Complete!
```

**Core rule:** Every command is taught, then used right away.

---

## 🗺️ Stage 1: Welcome to Linux

Stage 1 teaches filesystem navigation and basic file manipulation through three sections:

| Section | Focus | Commands | Mission |
|---------|-------|----------|---------|
| 🅰️ Navigate | Where am I? | `pwd` `ls` `ls -la` `cd` `cd ..` `cd ~` | Find the lost note |
| 🅱️ Files | Read, create, change | `cat` `less` `mkdir` `touch` `cp` `mv` `rm` | Organize cat's files |
| 🔐 Final | Put it all together | All of the above | Find the missing fish! 🐟 |

**Mental model you build:**

```
Where am I? → What's here? → Move → Read → Create → Copy → Rename → Delete
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

## 🧩 The Hidden Cat Mission

After learning all commands, the cat sends you on a treasure hunt:

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

---

## 🔄 Repetition System

Commands aren't taught once and forgotten. Each new lesson requires using previous commands:

```
pwd → ls + pwd → cd + pwd → cd + ls + pwd → cd + ls -la + cat → 🧩 Mission uses everything
```

> The player doesn't memorize commands — they get used to them.

---

## 🛡️ Safety

- 🧱 Everything runs in a sandbox directory (never touches your real system)
- ♻️ Stage 1: deleted files go to Cat's Trash Bin (recoverable)
- 🚫 Dangerous commands (`rm -rf /`, `sudo`, etc.) are blocked
- 🐳 Docker option for full isolation

---

## 🗂️ Project Structure

```
learn-linux-with-cat/
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
│   └── stage1/
│       ├── stage.conf    📋 Stage metadata + lesson order
│       ├── lessons/      📚 13 lesson scripts (01_pwd → 13_rm)
│       ├── missions/     🧩 3 missions (nav, file, hidden cat)
│       └── world/        🌍 Filesystem template
│
└── tests/                🧪 Engine, safety, checker, integration tests
```

---

## ⚙️ Architecture: Adding New Stages

The engine is **fully data-driven**. Adding Stage 2 requires **zero engine modifications**:

```
stages/stage2/
├── stage.conf           ← Define sections, lessons, missions
├── lessons/*.sh         ← Lesson scripts (same format as Stage 1)
├── missions/*.sh        ← Mission scripts
└── world/               ← New filesystem template
    └── home/catplayer/
```

The engine discovers stages via `stages/*/stage.conf`. Stage numbering determines order. Progress tracking handles transitions automatically.

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

---

## 🤝 Contributing

Want to add a new stage? See the architecture section above — each stage is a self-contained content package. Just add a new directory under `stages/` with the standard structure.

---

## 📜 License

MIT License — see [LICENSE](LICENSE)

---

```
   /\_/\
  ( ^.^ )   Happy learning!
   > ^ <
```
