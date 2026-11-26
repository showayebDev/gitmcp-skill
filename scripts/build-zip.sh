#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$REPO_ROOT/dist"
ZIP_PATH="$DIST_DIR/gitmcp.zip"

if [[ ! -f "$REPO_ROOT/gitmcp/SKILL.md" ]]; then
  echo "Error: missing gitmcp/SKILL.md" >&2
  exit 1
fi

mkdir -p "$DIST_DIR"
rm -f "$ZIP_PATH"

(
  cd "$REPO_ROOT"
  zip -rq "$ZIP_PATH" gitmcp
)

echo "Created $ZIP_PATH (ready for Claude Web and ChatGPT Web upload)."
