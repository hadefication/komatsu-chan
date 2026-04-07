---
name: update
description: Pull the latest komatsu-chan plugin changes. Use when the user says "update komatsu", "update plugin", or "/update".
---

# Update

Pull the latest komatsu-chan plugin changes from the repository.

## Usage

```
/update
```

No arguments.

## Execution

### 1. Find the plugin directory

The plugin lives wherever it was cloned. Locate it by finding the directory containing `.claude-plugin/plugin.json` with `"name": "komatsu-chan"`.

Common locations:
- `~/AI/komatsu-chan`
- `~/.claude/plugins/komatsu-chan`

```bash
PLUGIN_DIR=$(find ~/AI ~/.claude/plugins -name "plugin.json" -path "*komatsu-chan*" 2>/dev/null | head -1 | xargs dirname | xargs dirname)
```

### 2. Check for updates

```bash
cd "$PLUGIN_DIR"
git fetch origin
git log HEAD..origin/main --oneline
```

- If no new commits, say "komatsu-chan is already up to date."
- If there are new commits, show them and pull

### 3. Pull

```bash
git pull origin main
```

### 4. Re-run setup

```bash
chmod +x "$PLUGIN_DIR/bin/"*.sh
```

## Output

Up to date:
```
komatsu-chan is already up to date. (v<version>)
```

Updated:
```
komatsu-chan updated to latest.
  <commit count> new commits:
    <short log>

  Run /init to reconfigure if needed.
```
