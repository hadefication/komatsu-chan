---
name: cleanup
description: Clean up stale processes, caches, temp files, and docker artifacts. Use when the user says "cleanup", "clean up", "tidy up", "free space", or "/cleanup".
---

# Cleanup

One-command spring cleaning. Kills stale processes, clears caches, prunes docker, and removes temp files.

## Usage

```
/cleanup [target | dry-run]
```

- No args — run all cleanup tasks (with confirmation)
- `dry-run` — show what would be cleaned without doing it
- `<target>` — run a specific cleanup: `docker`, `node`, `laravel`, `temp`, `git`, `brew`

## Execution

### 1. Scan (always runs first)

Gather what can be cleaned (run in parallel):

```bash
# Docker
docker system df 2>/dev/null

# Node modules in temp/old locations
find ~/Herd -name "node_modules" -maxdepth 3 -type d 2>/dev/null | head -20

# Laravel caches (in current dir if it's a Laravel project)
ls -la storage/framework/cache/data/ 2>/dev/null
ls -la storage/framework/views/ 2>/dev/null
ls -la storage/framework/sessions/ 2>/dev/null

# Temp files
du -sh /tmp/com.apple.* 2>/dev/null
du -sh ~/Library/Caches/ 2>/dev/null

# Git
git gc --auto --dry-run 2>/dev/null

# Homebrew
brew cleanup --dry-run 2>/dev/null | tail -5
```

### 2. Report findings

Show a summary of what can be cleaned and approximate space savings:

```
Cleanup scan:
  Docker:     3.2 GB reclaimable (dangling images, build cache)
  Brew:       450 MB (old formula versions)
  Laravel:    12 MB cache (current project)
  Git:        needs gc
  Temp:       890 MB in system caches

Total: ~4.5 GB reclaimable
```

### 3. Confirm and execute

For `dry-run`, stop after the report.

Otherwise, **ask for confirmation** before proceeding — this is destructive.

Execute the chosen cleanups:

| Target | Command |
|--------|---------|
| `docker` | `docker system prune -f && docker builder prune -f` |
| `laravel` | `php artisan cache:clear && php artisan view:clear && php artisan config:clear` |
| `git` | `git gc --aggressive` (current repo) |
| `brew` | `brew cleanup` |
| `temp` | `rm -rf ~/Library/Caches/com.apple.dt.Xcode 2>/dev/null` (only safe targets) |

### Safety rules

- **Never** delete `node_modules` in active project directories without asking
- **Never** clear Laravel caches in production
- **Never** run `docker system prune -a` (keeps tagged images)
- **Never** delete files outside of known safe directories
- Always show what will be deleted before doing it
- If a command fails, report it and continue with the rest

## Output

After cleanup:
```
Cleanup complete:
  ✓ Docker:  freed 3.2 GB
  ✓ Brew:    freed 450 MB
  ✓ Laravel: caches cleared
  ✓ Git:     gc complete
  ─────────────────────
  Total freed: ~3.6 GB
```
