---
name: rcp
description: Cycle or set the permission mode of a Claude Code remote control session. Use when the user says "rcp", "rc perm", "rc permission", "permission mode", or "/rcp".
---

# RC Permission Mode

Cycle the permission mode of a running Claude Code remote control (rc) session by sending Shift+Tab keystrokes via tmux.

## Usage

```
/rcp [mode] [name]
```

- No args — cycle once on the rc session for the current directory
- `<mode>` — cycle until the target mode is reached
- `<name>` — target a specific rc session by directory name
- Both `<mode>` and `<name>` can be provided in any order

Valid modes: `auto`, `plan`, `acceptEdits`, `default`, `bypassPermissions`

## How It Works

Claude Code's TUI cycles permission modes with Shift+Tab. The tmux key for Shift+Tab is `BTab`.

### Cycle order

The modes available in the cycle depend on how the session was started. The rc skill starts with `--permission-mode auto`, so the cycle includes:

1. `acceptEdits` — displayed as `⏵⏵ accept edits on (shift+tab to cycle)`
2. `plan` — displayed as `⏸ plan mode on (shift+tab to cycle)`
3. `auto` — displayed as `⏵⏵ auto mode on (shift+tab to cycle)`
4. `default` — **not capturable** via `tmux capture-pane` (the mode indicator line is absent from output)

Other modes (`bypassPermissions`, `dontAsk`) only appear if explicitly enabled at startup.

## Execution

### Resolve the tmux session name

- If `<name>` is provided, use `claude-rc-<name>`
- If no name, derive from current directory: `claude-rc-$(basename $PWD)`
- Verify the session exists with `tmux has-session -t <session> 2>/dev/null`
- If session doesn't exist, say "No rc session found for `<name>`."

### Read the current mode

Capture the status line and extract the mode. Two icons are used: `⏵⏵` and `⏸`.

```bash
tmux capture-pane -t <session> -p -S -1 | grep -E '(⏵⏵|⏸).*shift\+tab' | sed 's/^[[:space:]]*//'
```

If the grep returns nothing, the current mode is `default` (its indicator is not visible in tmux captures).

Mode identification from the captured line:
- Contains "auto" → `auto`
- Contains "accept edits" → `acceptEdits`
- Contains "plan" → `plan`
- Empty/no match → `default`

### If no target mode (just cycle once)

```bash
tmux send-keys -t <session> BTab
sleep 1
```

Then read the new mode and report it.

### If a target mode is specified

1. Read the current mode first
2. If already on the target mode, report it and stop
3. Send `BTab`, wait 1s, read the mode — repeat up to 5 times until the target mode is detected
4. For `default` mode: detect by the **absence** of any mode indicator in the capture
5. Stop as soon as the target mode is reached

### If the mode isn't found after 5 cycles, report the current mode and say the target wasn't reached.

## Output

After cycling:
```
Permission mode → <display text>  (claude-rc-<dir>)
```

If target mode not reached:
```
Could not reach "<mode>" — currently on "<current mode>".  (claude-rc-<dir>)
```

If session not found:
```
No rc session found for "<name>".
```
