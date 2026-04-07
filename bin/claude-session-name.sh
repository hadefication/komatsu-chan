#!/usr/bin/env bash
#
# Generate a Claude session name.
# Usage: claude-session-name.sh [dir-name]
#
# Output: <user>@<machine>-<dir>-<date>-<time>
#

set -euo pipefail

RESOLVED_PATH="${1:-$PWD}"
MACHINE=$(system_profiler SPHardwareDataType 2>/dev/null | awk -F': ' '/Model Name/ {print $2}' | tr ' ' '-')
INSTANCE_DT=$(date +"%b%d%Y-%H%M" | tr '[:upper:]' '[:lower:]')

if [ "$(cd "$RESOLVED_PATH" 2>/dev/null && pwd || echo "$RESOLVED_PATH")" = "$HOME" ]; then
  echo "${USER}@${MACHINE}-${INSTANCE_DT}"
else
  DIR_NAME=$(basename "$RESOLVED_PATH")
  echo "${USER}@${MACHINE}-${DIR_NAME}-${INSTANCE_DT}"
fi
