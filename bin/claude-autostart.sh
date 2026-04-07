#!/usr/bin/env bash
#
# Auto-start Claude Code in tmux after boot.
# Called by LaunchAgent com.inggo.claude-autostart.
#

LOG="/tmp/claude-autostart.log"
log() { echo "$(date): $*" >> "$LOG"; }

export PATH="/opt/homebrew/bin:${HOME}/.local/bin:$PATH"

log "Script started"

# Wait for system to settle (network, login, etc.)
sleep 30

# Kill any stale tmux "claude" session (e.g. restored by tmux-continuum)
if tmux has-session -t claude 2>/dev/null; then
  log "Killing stale claude tmux session"
  tmux kill-session -t claude
  sleep 2
fi

# Build session name using shared script
SESSION_NAME=$("${HOME}/.claude/skills/rc/claude-session-name.sh")

# Start a fresh detached tmux session with a plain shell
tmux new-session -d -s claude -c "$HOME"
sleep 2

# Send the claude command with remote-control enabled from the start
tmux send-keys -t claude "claude --remote-control --name ${SESSION_NAME}" Enter

log "Sent claude command to tmux (name: ${SESSION_NAME}), waiting for it to start"

# Wait for the claude process to appear
MAX_WAIT=120
ELAPSED=0
while [ $ELAPSED -lt $MAX_WAIT ]; do
  if pgrep -f "claude.*${SESSION_NAME}" > /dev/null 2>&1; then
    log "Claude process detected after ${ELAPSED}s"
    break
  fi
  sleep 3
  ELAPSED=$((ELAPSED + 3))
done

if [ $ELAPSED -ge $MAX_WAIT ]; then
  log "Timed out waiting for Claude Code to start"
  exit 1
fi

# Give Claude Code time to fully initialize and connect remote control
sleep 15

tmux send-keys -t claude "Welcome back!" Enter

log "Autostart complete"
