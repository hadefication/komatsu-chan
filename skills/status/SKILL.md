---
name: status
description: Show a unified dashboard of all komatsu-chan services — rc sessions, caffeinate, and autostart. Use when the user says "status", "dashboard", "what's running", or "/status".
---

# Status

Unified dashboard showing the state of all komatsu-chan services.

## Usage

```
/status
```

No arguments.

## Execution

Gather status from all services in parallel, then display as a single dashboard.

### 1. Remote control sessions

```bash
tmux list-sessions -F '#{session_name} #{session_created}' 2>/dev/null | grep '^claude-rc-'
```

- If found, list each session with its creation time
- Also check for the autostart `claude` session: `tmux has-session -t claude 2>/dev/null`

### 2. Caffeinate

```bash
pgrep -l caffeinate
```

- If running, get details: `ps -o pid,etime,command -p $(pgrep caffeinate)`
- If not running, report as inactive

### 3. Autostart LaunchAgent

```bash
launchctl list | grep claude-autostart
```

- If loaded, report as active
- If not loaded, report as inactive

## Output

```
komatsu-chan status
─────────────────────────────

RC Sessions:
  claude-rc-event-platform  (started 2h ago)
  claude-rc-dotfiles        (started 15m ago)

Autostart:
  claude (main)             (started 6h ago)
  LaunchAgent:              active

Caffeinate:
  PID 12345                 (uptime 3:45:00, -di)

─────────────────────────────
```

If nothing is running:

```
komatsu-chan status
─────────────────────────────

RC Sessions:    none
Autostart:      inactive
Caffeinate:     inactive

─────────────────────────────
```
