---
name: journal
description: Daily dev journal — append timestamped entries about what you worked on. Use when the user says "journal", "log", "dev log", "note", "jot down", or "/journal".
---

# Journal

A daily dev journal. Quick timestamped notes about what you worked on, decisions made, or things to remember.

## Usage

```
/journal [entry | today | list | read <date>]
```

- `<entry>` — append an entry to today's journal (e.g., `/journal fixed the auth bug in login flow`)
- `today` — show today's journal entries
- `list` — list all journal files
- `read <date>` — read a specific day's journal (e.g., `/journal read 2026-04-07` or `/journal read yesterday`)
- No args — show today's entries (same as `today`)

## Storage

Journal files are stored at `~/.config/komatsu-chan/journal/`.

Filename: `<YYYY-MM-DD>.md` (one file per day, e.g., `2026-04-07.md`)

## Execution

### Adding an entry

1. Determine the journal file path for today: `~/.config/komatsu-chan/journal/<YYYY-MM-DD>.md`
2. If the file doesn't exist, create it with a header:
   ```markdown
   # Journal — <YYYY-MM-DD> (<day of week>)
   ```
3. Append the entry with a timestamp:
   ```markdown

   ## <HH:MM>
   <entry text>
   ```
4. If the user didn't provide entry text, ask what they'd like to log.

### Auto-context

When adding an entry, if the current directory is a git repo, automatically append context:
```markdown
> <directory basename> (`<branch>`)
```

### Showing today

1. Read `~/.config/komatsu-chan/journal/<today>.md`
2. If it doesn't exist, say "No journal entries for today."
3. Display the contents.

### Listing journals

```bash
ls -t ~/.config/komatsu-chan/journal/
```

Show the files with their sizes. If empty, say "No journal entries yet."

### Reading a specific date

1. Resolve the date — support `yesterday`, `monday`, `last friday`, or `YYYY-MM-DD`
2. Read the file and display it
3. If it doesn't exist, say "No journal entries for <date>."

## Output

After adding:
```
Logged at <HH:MM>.
```

Keep it minimal — the user is jotting a quick note, not writing a report.
