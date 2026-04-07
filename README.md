# komatsu-chan

A friendly dev assistant plugin for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

Named after Komatsu from Toriko — the loyal, resourceful partner who makes everything work.

## Skills

| Skill | Description |
|-------|-------------|
| `/rc` | Start, stop, and manage Claude Code remote control sessions via tmux |
| `/rcn` | Generate session names (`user@machine-dir-date-time`) |
| `/rcp` | Cycle permission modes on running rc sessions |
| `/staywoke` | Keep your Mac awake using caffeinate |
| `/autostart` | Auto-start Claude Code in a remote control session on boot |

## Requirements

- macOS
- [tmux](https://github.com/tmux/tmux)
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)

## Install

```bash
claude /plugin install inggo/komatsu-chan
```

Or add to a marketplace and install from there.

## Usage

Once installed, skills are available as slash commands:

```
/komatsu-chan:rc                  # start rc session for current directory
/komatsu-chan:rc event-platform   # start rc session for a specific project
/komatsu-chan:rc stop             # stop all rc sessions
/komatsu-chan:rcn                 # generate a session name
/komatsu-chan:rcp auto            # set permission mode to auto
/komatsu-chan:staywoke            # prevent sleep
/komatsu-chan:staywoke 30         # prevent sleep for 30 minutes
/komatsu-chan:autostart setup     # install auto-start on boot
```

## License

MIT
