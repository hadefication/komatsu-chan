#!/usr/bin/env bash
#
# Stop Claude Code remote-control session(s) in tmux.
# Usage: claude-rc-stop.sh [dir-name]
#
# Without args: stops all claude-rc-* sessions
# With arg: stops only claude-rc-<dir-name>
#

set -euo pipefail

export PATH="/opt/homebrew/bin:${HOME}/.local/bin:$PATH"

kill_session() {
  local session="$1"
  local dir="${session#claude-rc-}"

  # Get the PID of the tmux session's shell
  local shell_pid
  shell_pid=$(tmux list-panes -t "$session" -F '#{pane_pid}' 2>/dev/null | head -1)

  # Send Ctrl+C to gracefully deregister remote-control
  tmux send-keys -t "$session" C-c 2>/dev/null
  sleep 3

  # Kill the full process tree from the shell down
  if [ -n "${shell_pid:-}" ]; then
    # Find all descendant PIDs and kill them
    local pids
    pids=$(pgrep -P "$shell_pid" 2>/dev/null || true)
    for pid in $pids; do
      # Kill each child's tree recursively
      pkill -TERM -P "$pid" 2>/dev/null || true
      kill -TERM "$pid" 2>/dev/null || true
    done
    sleep 1
    # Force kill any survivors
    for pid in $pids; do
      pkill -KILL -P "$pid" 2>/dev/null || true
      kill -KILL "$pid" 2>/dev/null || true
    done
  fi

  # Kill the tmux session
  tmux kill-session -t "$session" 2>/dev/null || true

  echo "Remote control session \"${dir}\" stopped."
}

# Collect target sessions
if [ -n "${1:-}" ]; then
  TARGET="claude-rc-${1}"
  if ! tmux has-session -t "$TARGET" 2>/dev/null; then
    echo "No remote control session \"${1}\" found."
    exit 0
  fi
  kill_session "$TARGET"
else
  SESSIONS=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^claude-rc-' || true)
  if [ -z "$SESSIONS" ]; then
    echo "No remote control sessions to stop."
    exit 0
  fi
  for s in $SESSIONS; do
    kill_session "$s"
  done
  echo "All remote control sessions stopped."
fi
