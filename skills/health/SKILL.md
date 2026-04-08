---
name: health
description: System health check — disk space, memory, CPU, running services. Use when the user says "health", "system health", "how's the machine", "disk space", or "/health".
---

# Health

System health check for the local machine. Disk, memory, CPU, and key services.

## Usage

```
/health
```

No arguments.

## Execution

Run all checks in parallel:

### 1. Disk space

```bash
df -h / | tail -1
```

Parse used/available/percentage. Flag if over 85%.

### 2. Memory

```bash
vm_stat | head -10
# Also get a human-readable summary:
memory_pressure
```

Report memory pressure level (normal/warn/critical) and approximate usage.

### 3. CPU

```bash
top -l 1 -n 0 | grep "CPU usage"
```

Report user/system/idle percentages.

### 4. Load average

```bash
sysctl -n vm.loadavg
```

### 5. Services

Check key development services:

```bash
# MySQL
pgrep -l mysqld 2>/dev/null || echo "mysql: down"

# Redis
pgrep -l redis-server 2>/dev/null || echo "redis: down"

# PHP (Herd)
pgrep -l php-fpm 2>/dev/null || echo "php-fpm: down"

# Nginx (Herd)
pgrep -l nginx 2>/dev/null || echo "nginx: down"

# Docker
docker info --format '{{.ContainersRunning}} containers running' 2>/dev/null || echo "docker: not running"

# Node
pgrep -c node 2>/dev/null || echo "0"
```

### 6. Uptime

```bash
uptime
```

## Output

```
System Health
─────────────────────────────

Disk:      145 GB / 460 GB (31%) ✓
Memory:    normal pressure, ~12 GB used ✓
CPU:       8% user, 3% system, 89% idle ✓
Load:      1.2 1.4 1.1
Uptime:    3 days, 14:22

Services:
  MySQL       running (PID 1234)
  Redis       running (PID 1235)
  PHP-FPM     running (PID 1236)
  Nginx       running (PID 1237)
  Docker      3 containers running
  Node        5 processes

─────────────────────────────
All good.
```

If something is concerning:
```
  Disk:      420 GB / 460 GB (91%) ⚠ running low!
  Memory:    warn pressure ⚠
```

End with a one-liner assessment: "All good.", "Disk is getting tight.", "Memory pressure is high — might want to close some apps.", etc.
