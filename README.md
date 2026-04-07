# komatsu-chan

A friendly assistant plugin for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

Named after Komatsu from Toriko — the loyal, resourceful partner who makes everything work through skill and dedication, not brute force.

## Install

```
/plugin marketplace add hadefication/komatsu-chan
/plugin install komatsu-chan@komatsu-chan
```

## Getting Started

```
/komatsu-chan:init
```

The init wizard will:
- Check and install dependencies (tmux via Homebrew)
- Get to know you (name required, role/stack/vibe optional)
- Configure personality traits (TARS-style, 0–100)
- Optionally enable auto-start on boot

## Skills

| Skill | Description |
|-------|-------------|
| `/init` | First-time setup wizard |
| `/rc` | Remote control sessions via tmux |
| `/rcn` | Generate session names |
| `/rcp` | Cycle permission modes on rc sessions |
| `/staywoke` | Keep your Mac awake using caffeinate |
| `/autostart` | Auto-start Claude Code on boot |
| `/status` | Unified dashboard of all services |
| `/personality` | Reconfigure personality traits |
| `/whoami` | komatsu-chan introduces itself |
| `/update` | Pull latest plugin changes |

## Requirements

- macOS
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- [Homebrew](https://brew.sh) (for installing tmux)

## Usage

```
/komatsu-chan:rc                    # start rc session for current directory
/komatsu-chan:rc event-platform     # start rc session for a specific project
/komatsu-chan:rc stop               # stop all rc sessions
/komatsu-chan:rcn                   # generate a session name
/komatsu-chan:rcp auto              # set permission mode to auto
/komatsu-chan:staywoke              # prevent sleep
/komatsu-chan:staywoke 30           # prevent sleep for 30 minutes
/komatsu-chan:status                # see what's running
/komatsu-chan:personality humor 90  # adjust a trait
/komatsu-chan:whoami                # meet your assistant
```

## Personality

komatsu-chan has configurable personality traits, inspired by TARS from Interstellar:

| Trait | Default | What it controls |
|-------|---------|-----------------|
| Humor | 75 | Playful ↔ Professional |
| Honesty | 90 | Diplomatic ↔ Blunt |
| Verbosity | 40 | Terse ↔ Thorough |
| Encouragement | 80 | Neutral ↔ Cheerleader |
| Sass | 30 | Polite ↔ Snarky |
| Sarcasm | 40 | Sincere ↔ Dripping with irony |

Set during `/init` or change anytime with `/personality`. Traits are written as a natural language prompt into your `~/.claude/CLAUDE.md` — no numbers, just personality.

## How It Works

komatsu-chan is a collection of [Claude Code skills](https://docs.anthropic.com/en/docs/claude-code) — prompt-based instructions that Claude reads and executes. Shell scripts in `bin/` handle the heavier operations (tmux session management, process trees, etc.).

Configuration lives in `~/.config/komatsu-chan/`:
- `personality.json` — trait values
- `user.json` — user profile

## License

MIT
