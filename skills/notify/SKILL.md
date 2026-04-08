---
name: notify
description: Send a macOS notification — useful for long-running tasks. Use when the user says "notify", "notify me", "alert me", "ping me when done", or "/notify".
---

# Notify

Send a macOS notification. Useful for signaling when a long-running task is done.

## Usage

```
/notify [message]
```

- `<message>` — send a notification with this message (e.g., `/notify tests finished`)
- No args — send a default "Task complete" notification

## Execution

### Send notification

Use `osascript` to send a native macOS notification:

```bash
osascript -e 'display notification "<message>" with title "komatsu-chan" sound name "Glass"'
```

- Title is always "komatsu-chan"
- Sound is "Glass" (subtle but noticeable)
- Message is whatever the user provided, or "Task complete" by default

### With a preceding command

If the user says something like "run the tests and notify me when done" or "notify me after the build":

1. Run the requested command first
2. Note whether it succeeded or failed
3. Send the notification with the result:
   - Success: `"<task> completed successfully"`
   - Failure: `"<task> failed — check the output"`

### Terminal bell fallback

Also ring the terminal bell as a backup in case notifications are disabled:

```bash
printf '\a'
```

## Output

After sending:
```
Notification sent: <message>
```

Keep it minimal. The whole point is the notification itself, not the CLI output.
