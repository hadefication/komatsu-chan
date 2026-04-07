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

### 5. Configure personality

Run the `/personality` skill to configure komatsu-chan's traits. This handles asking for values, generating the prompt, and writing to `~/.claude/CLAUDE.md`.

### 7. Configure project registry

Ask the user for directories where their projects live. These paths let `/rc <name>` resolve a project name to a full path without the user typing it out.

```
Where do your projects live?
Enter directory paths (one per line, empty line to finish):

  > ~/Herd
  > ~/AI
  >
```

Save to `~/.config/komatsu-chan/projects.json`:

```bash
mkdir -p ~/.config/komatsu-chan
```

```json
{
  "project_dirs": [
    "/Users/glen/Herd",
    "/Users/glen/AI"
  ]
}
```

- Expand `~` to `$HOME` before saving
- Validate that each path exists
- If a path doesn't exist, warn and skip it
- If the user skips this step (empty input immediately), save an empty array

### 8. Ask about autostart

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

### 9. Report

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

  Projects:    <list of registered dirs, or "none">
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
