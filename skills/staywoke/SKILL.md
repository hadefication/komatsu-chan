---
name: staywoke
description: Keep your Mac awake using caffeinate. Start, stop, and check status of caffeinate sessions. Use when the user says "staywoke", "keep awake", "don't sleep", "stay awake", "stay woke", or "/staywoke".
---

# Stay Woke

Manage caffeinate sessions to keep your Mac awake.

## Usage

```
/staywoke [mode|minutes|status|stop]
```

- No args or `on` — prevent idle + display sleep
- `display` — only prevent display sleep
- `idle` — only prevent idle sleep
- `system` — prevent system sleep
- `<number>` — timed session in minutes (prevents idle + display sleep)
- `<number> <mode>` — timed session with specific mode (e.g., `/staywoke 30 display`)
- `status` — check if caffeinate is currently running
- `stop` or `off` — stop all caffeinate sessions

## Execution

### For `status`

Check if caffeinate is running:

```bash
pgrep -l caffeinate
```

- If running, show PID(s) and uptime: `ps -o pid,etime,command -p <pid>`
- If not running, say "No caffeinate sessions running."

### For `stop` / `off`

```bash
pkill caffeinate
```

- Confirm by running `pgrep caffeinate` after
- If none were running, say "No caffeinate sessions to stop."

### For starting a session

1. **Check for existing sessions** — run `pgrep -l caffeinate`. If already running, tell the user and ask if they want to stop the existing session first or keep both.

2. **Build the command** based on mode:
   | Mode | Flags |
   |---|---|
   | (default) / `on` | `-di` |
   | `display` | `-d` |
   | `idle` | `-i` |
   | `system` | `-s` |

3. **Add timer** if a number (minutes) was provided: append `-t <minutes * 60>`

4. **Run detached** so it survives after the Claude Code session ends:
   ```bash
   nohup caffeinate <flags> > /dev/null 2>&1 & disown
   ```

5. **Confirm** by running `pgrep -l caffeinate` and report the PID.

## Output

After starting:
```
Caffeinate started (PID <pid>) — preventing <mode> sleep<timer info>.
Stop with: /staywoke stop
```

After stopping:
```
Caffeinate stopped. Your Mac can sleep normally now.
```

Status (running):
```
Caffeinate is running (PID <pid>, uptime <time>) — <command>
```

Status (not running):
```
No caffeinate sessions running.
```
