---
name: autostart
description: Set up Claude Code to auto-start in a tmux remote control session after boot via macOS LaunchAgent. Use when the user says "autostart", "auto launch", "start on boot", or "/autostart".
---

# Autostart

Set up Claude Code to automatically start in a tmux remote control session after your Mac boots.

## Usage

```
/autostart [setup|status|stop]
```

- `setup` or no args — install the LaunchAgent and autostart script
- `status` — check if the LaunchAgent is loaded and the tmux session is running
- `stop` or `off` — unload the LaunchAgent

## How It Works

A macOS LaunchAgent (`com.komatsu-chan.claude-autostart`) runs a shell script at login that:

1. Waits 30s for the system to settle
2. Kills any stale `claude` tmux session (e.g., restored by tmux-continuum)
3. Creates a fresh detached tmux session named `claude`
4. Starts `claude --remote-control --name <session-name>` inside it
5. Waits for the Claude process to appear (up to 120s)
6. Sends a "Welcome back!" message

## Execution

### For `setup`

1. Copy the autostart script to `~/bin/`:
   ```bash
   mkdir -p ~/bin
   cp "$(dirname "$0")/../bin/claude-autostart.sh" ~/bin/claude-autostart.sh
   chmod +x ~/bin/claude-autostart.sh
   ```

2. Generate the plist from the template by replacing `__HOME__` with the user's home directory, then load it:
   ```bash
   mkdir -p ~/Library/LaunchAgents
   sed "s|__HOME__|$HOME|g" "$(dirname "$0")/../bin/com.komatsu-chan.claude-autostart.plist" > ~/Library/LaunchAgents/com.komatsu-chan.claude-autostart.plist
   launchctl load ~/Library/LaunchAgents/com.komatsu-chan.claude-autostart.plist
   ```

3. Confirm the agent is loaded:
   ```bash
   launchctl list | grep claude-autostart
   ```

### For `status`

```bash
launchctl list | grep claude-autostart
tmux has-session -t claude 2>/dev/null && echo "tmux session 'claude' is running" || echo "No tmux session 'claude' found"
```

### For `stop` / `off`

```bash
launchctl unload ~/Library/LaunchAgents/com.komatsu-chan.claude-autostart.plist
```

## Output

After setup:
```
Autostart installed.
  Script:       ~/bin/claude-autostart.sh
  LaunchAgent:  ~/Library/LaunchAgents/com.komatsu-chan.claude-autostart.plist

Claude Code will start automatically on next login.
```

Status (loaded):
```
Autostart is active (LaunchAgent loaded).
tmux session 'claude' is running.
```

Status (not loaded):
```
Autostart is not active (LaunchAgent not loaded).
```
