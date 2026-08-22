#!/bin/bash
# Refresh the AI news digest. Invoked by launchd every 5 hours; safe to run by hand.
set -euo pipefail

export PATH="/opt/homebrew/bin:$HOME/.local/bin:$PATH"
cd "$(dirname "$0")/.."

echo "=== $(date '+%Y-%m-%d %H:%M:%S %Z') starting ==="

# Land on top of anything pushed elsewhere before writing.
git pull --rebase --quiet || echo "warning: git pull failed, continuing with local state"

# stdin from /dev/null: a CLI that reads piped stdin never reaches EOF when its
# parent holds the pipe open, and launchd would hang the job forever.
claude -p "$(cat prompts/update.md)" \
  --permission-mode acceptEdits \
  --allowedTools Bash Read Write Edit Glob Grep WebSearch WebFetch \
  < /dev/null

echo "=== $(date '+%Y-%m-%d %H:%M:%S %Z') finished ==="
