#!/usr/bin/env bash
#
# Start a Claude Code remote-control session in tmux.
# Usage: claude-rc.sh [project-dir]
#
# - tmux session name: claude-rc-<dir>
# - Claude session name: <user>@<machine>-<dir>-<date>-<time>
#

set -euo pipefail

export PATH="/opt/homebrew/bin:${HOME}/.local/bin:$PATH"

PROJECT_DIR="${1:-$PWD}"
DIR_NAME=$(basename "$PROJECT_DIR")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

TMUX_SESSION="claude-rc-${DIR_NAME}"
CLAUDE_NAME=$("${SCRIPT_DIR}/claude-session-name.sh" "$PROJECT_DIR")

# Check if session already exists
if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  echo "Session \"${TMUX_SESSION}\" already exists."
  echo "Stop it first with: /rc stop ${DIR_NAME}"
  exit 1
fi

# Create tmux session in the project directory
tmux new-session -d -s "$TMUX_SESSION" -c "$PROJECT_DIR"
sleep 1

# Change to project directory first
tmux send-keys -t "$TMUX_SESSION" "cd '${PROJECT_DIR}'" Enter
sleep 1

# Start claude with remote-control enabled
tmux send-keys -t "$TMUX_SESSION" "claude --remote-control --name '${CLAUDE_NAME}' --permission-mode auto" Enter

# Verify session is running
sleep 1
if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  echo "Remote control session started."
  echo "  tmux session:  ${TMUX_SESSION}"
  echo "  Claude name:   ${CLAUDE_NAME}"
  echo "  Project dir:   ${PROJECT_DIR}"
  echo ""
  echo "Connect from claude.ai/code."
  echo "Stop with:   /rc stop ${DIR_NAME}"

  # Open a new Terminal window attached to the tmux session
  osascript -e "tell application \"Terminal\"
    do script \"tmux attach -t ${TMUX_SESSION}\"
    activate
  end tell"
else
  echo "Failed to start session."
  exit 1
fi
