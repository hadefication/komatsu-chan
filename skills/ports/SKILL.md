---
name: ports
description: Show what's running on which ports — quick view of local services. Use when the user says "ports", "what's running", "check ports", "who's on port", or "/ports".
---

# Ports

Show what processes are listening on which ports. Quick way to see what services are up.

## Usage

```
/ports [port | kill <port>]
```

- No args — show all listening ports
- `<port>` — check what's on a specific port (e.g., `/ports 8000`)
- `kill <port>` — kill the process on a specific port

## Execution

### Show all ports

```bash
lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null | tail -n +2
```

Parse and display as a clean table:

```
Port    Process          PID
────    ───────          ───
3000    node             12345
5173    node (vite)      12346
8000    php-fpm          12347
8025    mailhog          12348
3306    mysqld           12349
6379    redis-server     12350
```

Group by well-known services when possible:
- 3306 → MySQL
- 5432 → PostgreSQL
- 6379 → Redis
- 8000/8080 → likely Laravel/PHP
- 3000/5173 → likely Node/Vite
- 9000 → PHP-FPM
- 80/443 → Nginx/Herd

### Check specific port

```bash
lsof -iTCP:<port> -sTCP:LISTEN -P -n 2>/dev/null
```

- If something is listening, show the process name, PID, and command
- If nothing, say "Nothing listening on port <port>."

### Kill a port

1. Find the PID: `lsof -ti TCP:<port>`
2. Confirm with the user what process it is before killing
3. Kill it: `kill <pid>`
4. Verify: `lsof -ti TCP:<port>` (should be empty)
5. If the process doesn't die, suggest `kill -9 <pid>`

## Output

All ports:
```
Local ports in use:
  :3000   node (vite)        PID 12345
  :8000   php (artisan)      PID 12346
  :3306   mysqld             PID 12347
  :6379   redis-server       PID 12348

4 services listening.
```

Empty:
```
No ports in use. Ghost town.
```
