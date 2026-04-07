---
name: rcn
description: Generate a Claude session name. Use when the user says "rcn", "session name", "name this session", "give me a session name", or "/rcn".
---

# RC Name

Generate a Claude session name using the convention: `<user>@<machine>-<dir>-<date>-<time>`.

## Usage

```
/rcn [path]
```

- No args — uses the current working directory's basename
- `<path>` — uses the basename of the provided path (e.g., `/Users/glen/Herd/event-platform` → `event-platform`)

## Execution

Run the shared script from the rc skill:

```bash
bash ~/.claude/skills/rc/claude-session-name.sh [path]
```

- If no path was provided, pass nothing (the script defaults to `$PWD`)
- If a path was provided, pass it as the first argument

## Output

Print the generated name as-is:

```
glenbangkila@MacBook-Air-statusline-setup-apr072026-1151
```
