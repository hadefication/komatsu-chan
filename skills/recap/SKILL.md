---
name: recap
description: Summarize recent git activity or session work — quick "where was I?" after a break. Use when the user says "recap", "what did I do", "catch me up", "where was I", or "/recap".
---

# Recap

Quick summary of recent work — git activity, uncommitted changes, and current state. Perfect for "where was I?" moments.

## Usage

```
/recap [N | today | week | path]
```

- No args — recap the last 24 hours in the current repo
- `<N>` — recap the last N commits (e.g., `/recap 20`)
- `today` — only today's commits
- `week` — this week's commits
- `<path>` — recap a specific project directory

## Execution

### 1. Gather git data (run in parallel)

```bash
# Recent commits (default: last 24h, or as specified)
git log --oneline --since="24 hours ago" --all
# Or for N commits:
git log --oneline -N

# Current state
git status --short
git branch --show-current
git stash list

# What changed
git diff --stat HEAD~5..HEAD 2>/dev/null
```

### 2. Check for journal entries

If `~/.config/komatsu-chan/journal/<today>.md` exists, include a note about it.

### 3. Check for handoffs

If `~/.config/komatsu-chan/handoffs/` has recent files (last 48h), mention them.

### 4. Generate the recap

Summarize into a concise, scannable format:

```
Recap — <directory> (<branch>)
─────────────────────────────

Commits (last 24h): <count>
  <grouped by theme/area, not just listing commits>

Uncommitted:
  <modified/staged/untracked summary>

Stashes: <count or "none">

Journal: <"3 entries today" or "no entries">
Handoff: <"available from <date>" or "none">
```

### 5. End with orientation

Finish with a one-liner like: "Looks like you were working on X. Pick up there?"

## Guidelines

- Group commits by theme, don't just dump the log
- Highlight anything that looks unfinished (uncommitted changes, WIP commits, open stashes)
- If the repo has no recent activity, say so plainly
- If not in a git repo, say "Not a git repo. Nothing to recap."
