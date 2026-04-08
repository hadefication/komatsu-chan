---
name: briefing
description: Morning briefing — open PRs, recent commits, running sessions, and project status across active repos. Use when the user says "briefing", "morning", "what's happening", "start of day", or "/briefing".
---

# Briefing

Morning briefing. Get oriented across all active projects with one command.

## Usage

```
/briefing [project]
```

- No args — briefing across all known project directories
- `<project>` — briefing for a specific project only

## Project directories

Scan for git repos in these locations:
- `~/Herd/` (Laravel projects)
- `~/AI/` (AI projects)

Only include repos with activity in the last 7 days (based on most recent commit date).

## Execution

### 1. Active projects (run in parallel per repo)

For each active repo:

```bash
cd <repo>
git log --oneline -5 --since="7 days ago"
git status --short
git branch --show-current
```

### 2. Open PRs

```bash
gh pr list --author @me --state open --json title,url,number,repository,updatedAt 2>/dev/null
```

Also check for PRs that need review:

```bash
gh pr list --search "review-requested:@me" --state open --json title,url,number,repository 2>/dev/null
```

### 3. Running services

Check komatsu-chan services:
- RC sessions: `tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^claude-rc-'`
- Autostart: `tmux has-session -t claude 2>/dev/null`
- Caffeinate: `pgrep -l caffeinate 2>/dev/null`

### 4. Today's journal

Check if there are journal entries for today: `~/.config/komatsu-chan/journal/<today>.md`

### 5. Recent handoffs

Check for handoffs from the last 48 hours: `ls -t ~/.config/komatsu-chan/handoffs/ | head -5`

## Output

```
Good morning! Here's what's going on.
─────────────────────────────

Active Projects (last 7 days):
  event-platform (main)     3 commits, clean
  komatsu-chan (main)        1 commit, 2 modified files
  dotfiles (main)            5 commits, clean

Open PRs:
  #142 "Add webhook retry logic"     event-platform  (updated 2h ago)
  #89  "Fix date parsing"            campaign-builder (updated 1d ago)

Review Requests:
  #201 "Refactor auth middleware"     event-platform

Services:
  RC:          claude-rc-event-platform (started 14h ago)
  Autostart:   active
  Caffeinate:  inactive

Journal:       no entries today
Handoffs:      event-platform-2026-04-06.md (yesterday)

─────────────────────────────
```

If `gh` is not installed or not authenticated, skip the PR sections and note it.

## Guidelines

- Keep it scannable — the user wants a quick overview, not a deep dive
- Highlight anything that needs attention (stale PRs, uncommitted changes, review requests)
- Use relative times ("2h ago", "yesterday") not absolute timestamps
- If nothing interesting is happening, keep it short: "All quiet. No open PRs, no uncommitted changes."
