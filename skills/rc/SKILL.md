---
name: rc
description: Start, stop, and check status of Claude Code remote control sessions via tmux. Use when the user says "rc", "remote control", "remote session", or "/rc".
---

# Remote Control

Manage Claude Code remote control sessions using tmux (required for persistent TTY).

## Usage

```
/rc [name|status|stop|list]
```

- No args — start a session for the current directory
- `<name>` — start a session for a specific project directory name
- `status` — check if a remote control session is running
- `list` — list all remote control tmux sessions
- `stop` or `off` — stop all remote control sessions
- `stop <name>` — stop a specific session by its tmux name (the dir part)

## Naming Convention

Two names are used per session:

- **tmux session name**: `claude-rc-<dir>` (e.g., `claude-rc-event-platform`)
- **Claude session name**: `<user>@<machine>-<dir>-<date>-<time>` (e.g., `inggo@Mac-mini-event-platform-apr062026-0930`)

The tmux name is short for easy attachment. The Claude name is rich for identification in claude.ai/code.

## Execution

### For `status` / `list`

List all remote control tmux sessions:

```bash
tmux list-sessions -F '#{session_name} #{session_created}' 2>/dev/null | grep '^claude-rc-'
```

- If found, show session names and creation times
- If none found, say "No remote control sessions running."

### For `stop` / `off`

Run the `claude-rc-stop.sh` script bundled with this skill:

```bash
bash ~/.claude/skills/rc/claude-rc-stop.sh [name]
```

- Without a name — stops all `claude-rc-*` sessions
- With a name — stops only that specific session (pass just the dir name, e.g., `event-platform`)

The script handles:
1. Finding the Claude process tree inside the tmux session
2. Sending `Ctrl+C` to gracefully deregister remote-control
3. Killing the full process tree (Claude + spawned subagents/commands)
4. Killing the tmux session
5. Confirming cleanup

- If none were running, say "No remote control sessions to stop."

### For starting a session

Run the `claude-rc.sh` script bundled with this skill:

```bash
bash ~/.claude/skills/rc/claude-rc.sh <project-dir>
```

- If no name/dir was provided, pass `$PWD` (the current working directory)
- If a name was provided, resolve it to a directory path using the project registry:
  1. Read `~/.config/komatsu-chan/projects.json` for registered project directories
  2. Search each registered directory for a subdirectory matching the name
  3. If found, pass the full path
  4. If not found in the registry, check if it's an absolute path or relative to `$PWD`
  5. If still not found, report the error

The script handles:
1. Building the tmux session name (`claude-rc-<dir>`) and Claude session name (`<user>@<machine>-<dir>-<date>-<time>`)
2. Checking for existing sessions
3. Creating the tmux session in the project directory (`-c`)
4. Sending the `claude --remote-control --permission-mode auto` command (normal TUI with remote-control enabled)
5. Verifying and reporting

## Output

After starting:
```
Remote control session started.
  tmux session:  claude-rc-<dir>
  Claude name:   <user>@<machine>-<dir>-<date>-<time>
  Project dir:   /path/to/<dir>

Connect from claude.ai/code.
Attach with: tmux attach -t claude-rc-<dir>
Stop with:   /rc stop <dir>
```

After stopping:
```
Remote control session "<dir>" stopped.
```

After stopping all:
```
All remote control sessions stopped.
```

Status (running):
```
Remote control sessions:
  - claude-rc-<dir> (started <time>)
```

Status (not running):
```
No remote control sessions running.
```
