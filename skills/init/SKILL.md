---
name: init
description: Initialize komatsu-chan plugin — check dependencies, configure personality, and set up the environment. Use when the user says "init", "initialize", "setup", or "/init".
---

# Init

Set up komatsu-chan and its dependencies.

## Usage

```
/init
```

No arguments. Run once after installing the plugin.

## Execution

Run through the following steps in order. Stop and report if a required dependency can't be installed.

### 1. Check Homebrew

```bash
command -v brew
```

- If found, continue
- If missing, tell the user to install it from https://brew.sh and stop

### 2. Check and install tmux

```bash
command -v tmux
```

- If found, report the version (`tmux -V`) and continue
- If missing, ask the user if they want to install it via Homebrew
  - If yes: `brew install tmux`
  - If no: warn that rc, rcp, and autostart skills require tmux, then continue

### 3. Set up bin scripts

```bash
PLUGIN_BIN="$(dirname "$0")/../bin"
chmod +x "$PLUGIN_BIN"/*.sh
```

### 4. Create ~/bin

```bash
mkdir -p ~/bin
```

### 5. Get to know the user (optional)

Ask the user about themselves. Name is required, everything else is optional — they can skip with an empty response.

```
Let's get acquainted.

  Name:   _          (required)
  Role:   _          (optional — e.g., backend dev, student, designer)
  Stack:  _          (optional — e.g., Laravel/PHP, React/TS, Python)
  Vibe:   _          (optional — e.g., "pair programming", "just get it done", "teach me")
```

- **Name** — what to call them (required, keep asking until provided)
- **Role** — what they do
- **Stack** — what they mainly work with
- **Vibe** — how they like to work

Save to `~/.config/komatsu-chan/user.json`:

```json
{
  "name": "Glen",
  "role": "full-stack dev",
  "stack": "Laravel, React",
  "vibe": "just get it done"
}
```

Include the user info in the `## komatsu-chan` section of `~/.claude/CLAUDE.md` when generating the personality prompt. Add a line like:

```
You're working with <name>, a <role> who works with <stack>. They prefer a <vibe> style of collaboration.
```

Only include fields the user actually provided beyond the name. The name is always included.

### 6. Configure personality

Run the `/personality` skill to configure komatsu-chan's traits. This handles asking for values, generating the prompt, and writing to `~/.claude/CLAUDE.md`.

### 7. Ask about autostart

Ask the user if they want Claude Code to auto-start on boot via LaunchAgent.

- If yes, run the autostart setup (same steps as `/autostart setup`):
  ```bash
  cp "$PLUGIN_BIN/claude-autostart.sh" ~/bin/claude-autostart.sh
  chmod +x ~/bin/claude-autostart.sh
  mkdir -p ~/Library/LaunchAgents
  sed "s|__HOME__|$HOME|g" "$PLUGIN_BIN/com.komatsu-chan.claude-autostart.plist" > ~/Library/LaunchAgents/com.komatsu-chan.claude-autostart.plist
  launchctl load ~/Library/LaunchAgents/com.komatsu-chan.claude-autostart.plist
  ```
- If no, skip

### 8. Report

Show a summary of what was set up:

```
komatsu-chan initialized.

  Dependencies:
    Homebrew:  ✓
    tmux:      ✓ (<version>)

  Personality:
    Humor:         <value>
    Honesty:       <value>
    Verbosity:     <value>
    Encouragement: <value>
    Sass:          <value>

  Autostart:   <enabled / skipped>

  Available skills:
    /rc          — remote control sessions
    /rcn         — session name generator
    /rcp         — permission mode cycling
    /staywoke    — caffeinate management
    /autostart   — auto-start on boot
    /status      — unified dashboard
    /personality — reconfigure traits
    /whoami      — komatsu-chan introduces itself
    /update      — pull latest changes
    /init        — reconfigure (run again anytime)
```
