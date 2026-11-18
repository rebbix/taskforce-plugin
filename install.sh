#!/bin/sh
# One command: add the Taskforce marketplace, install the plugin, add its permission entries.
# Downloads nothing itself; `claude` installs the plugin.
set -eu

if ! command -v claude >/dev/null 2>&1; then
  echo "install: the claude command is not on PATH. Install Claude Code first, then run this again." >&2
  exit 1
fi

marketplace="${TASKFORCE_MARKETPLACE:-https://github.com/rebbix/taskforce-plugin.git}"

claude plugin marketplace add "$marketplace"
claude plugin install taskforce@taskforce

# The installed plugin's own program writes the permission entries.
program="$(ls -d "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"/plugins/cache/taskforce/taskforce/*/bin/taskforce 2>/dev/null | sort -V | tail -n 1 || true)"
if [ -z "$program" ]; then
  echo "install: the plugin is installed, but its program was not found under the Claude Code plugins folder; no permission entries were added." >&2
  exit 1
fi
"$program" allow

echo "Next: paste the invite text of a taskforce into a Claude Code session."
