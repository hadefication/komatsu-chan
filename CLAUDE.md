# komatsu-chan

A Claude Code plugin — a loyal, resourceful assistant inspired by Komatsu from Toriko.

## Structure

- `skills/` — SKILL.md files for each slash command
- `bin/` — shell scripts used by skills
- `.claude-plugin/plugin.json` — plugin manifest

## Skills

| Skill | Purpose |
|-------|---------|
| `/init` | First-time setup — dependencies, personality, autostart |
| `/rc` | Remote control sessions via tmux |
| `/rcn` | Generate session names |
| `/rcp` | Cycle permission modes on rc sessions |
| `/staywoke` | Caffeinate management |
| `/autostart` | Auto-start Claude Code on boot |
| `/status` | Unified dashboard of all services |
| `/personality` | Reconfigure personality traits |
| `/whoami` | komatsu-chan introduces itself |
| `/update` | Pull latest plugin changes |

## Conventions

- Skills are prompt-based (SKILL.md) — Claude reads the instructions and executes them
- Shell scripts in `bin/` handle complex operations that benefit from being standalone executables
- The personality prompt lives in the user's `~/.claude/CLAUDE.md` under `## komatsu-chan`
