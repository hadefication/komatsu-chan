---
name: handoff
description: Export a session summary (what was done, pending items, key decisions) for seamless pickup in a new session. Use when the user says "handoff", "save session", "session summary", "wrap up", or "/handoff".
---

# Handoff

Export a summary of the current session so it can be picked up in a new conversation without losing context.

## Usage

```
/handoff [name]
```

- No args — auto-generates a name from the current directory and date
- `<name>` — custom name for this handoff (e.g., `auth-refactor`)

## Storage

Handoff files are stored at `~/.config/komatsu-chan/handoffs/`.

Filename: `<name>-<YYYY-MM-DD>.md` (e.g., `event-platform-2026-04-07.md`)

## Execution

### 1. Gather context

Collect the following information:

**From git** (run in parallel):
```bash
git log --oneline -20
git diff --stat
git status --short
git branch --show-current
```

**From the conversation:**
- What was the user working on (goals/tasks)
- What was completed
- What's still pending or blocked
- Key decisions made and why
- Any gotchas or context that would be non-obvious to a fresh session

### 2. Generate the handoff file

Write a markdown file with this structure:

```markdown
# Handoff: <name>

**Date:** <YYYY-MM-DD HH:MM>
**Directory:** <pwd>
**Branch:** <current branch>

## What was done
- <bullet points of completed work>

## Still pending
- <bullet points of remaining work, if any>

## Key decisions
- <decisions made and why — this is the most valuable section>

## Context & gotchas
- <anything non-obvious a fresh session needs to know>

## Recent commits
<last 10 commits, one-line format>

## Uncommitted changes
<git status --short output, or "Clean working tree">
```

### 3. Confirm

Print the path and a brief summary.

## Loading a handoff

When a user says "load handoff", "pick up where I left off", or "continue from last session":

1. List available handoffs: `ls -t ~/.config/komatsu-chan/handoffs/`
2. If multiple exist, show them and ask which one (or default to the most recent)
3. Read the file and present the summary
4. Offer to continue the pending work

## Output

After saving:
```
Handoff saved: ~/.config/komatsu-chan/handoffs/<name>-<date>.md

Summary:
  Done:    <count> items
  Pending: <count> items
  Branch:  <branch>

Load in a new session with: /handoff load
```

After loading:
```
Loaded handoff: <name> (<date>)

<summary of what was done and what's pending>

Ready to pick up where you left off.
```
