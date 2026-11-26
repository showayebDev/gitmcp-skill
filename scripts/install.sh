#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="$REPO_ROOT/gitmcp"
GITMCP_URL="https://gitmcp.io/docs"
SKIP_MCP=0
TARGETS=()

usage() {
  cat <<EOF
Usage: $(basename "$0") [--skip-mcp] [target...]

Targets:
  all          Install for antigravity, gemini, claude, codex (default)
  antigravity  Google Antigravity (~/.gemini/config/skills/gitmcp + mcp_config.json)
  gemini       Gemini CLI (~/.gemini/skills/gitmcp + settings.json)
  claude       Claude Code / CLI (~/.claude/skills/gitmcp + MCP)
  codex        OpenAI Codex (~/.agents/skills/gitmcp + ~/.codex/config.toml)
  cursor       Cursor (~/.cursor/skills/gitmcp + ~/.cursor/mcp.json)
  windsurf     Windsurf (~/.agents/skills/gitmcp + ~/.codeium/windsurf/mcp_config.json)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-mcp) SKIP_MCP=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) TARGETS+=("$1"); shift ;;
  esac
done

if [[ ${#TARGETS[@]} -eq 0 ]]; then
  TARGETS=("all")
fi

if [[ " ${TARGETS[*]} " == *" all "* ]]; then
  TARGETS=("antigravity" "gemini" "claude" "codex")
fi

copy_skill() {
  local dest="$1"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  cp -R "$SKILL_SRC" "$dest"
  echo "  [Skill] Installed to $dest"
}

merge_json_mcp() {
  local config_path="$1"
  local entry_json="$2"
  mkdir -p "$(dirname "$config_path")"

  if command -v python3 >/dev/null 2>&1; then
    python3 - "$config_path" "$entry_json" <<'PY'
import json, os, sys
path, entry_raw = sys.argv[1], sys.argv[2]
entry = json.loads(entry_raw)
data = {}
if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read().strip()
        if content:
            data = json.loads(content)
if not isinstance(data.get("mcpServers"), dict):
    data["mcpServers"] = {}
data["mcpServers"]["gitmcp"] = entry
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
    echo "  [MCP]   Configured gitmcp in $config_path"
  else
    echo "  [Warn]  python3 not found; please merge $entry_json into $config_path manually."
  fi
}

merge_codex_toml() {
  local toml_path="$1"
  mkdir -p "$(dirname "$toml_path")"
  if [[ -f "$toml_path" ]] && grep -qE '^\[mcp_servers\.gitmcp\]' "$toml_path"; then
    echo "  [MCP]   gitmcp already present in $toml_path"
    return
  fi
  printf '\n[mcp_servers.gitmcp]\nurl = "%s"\n' "$GITMCP_URL" >> "$toml_path"
  echo "  [MCP]   Configured gitmcp in $toml_path"
}

for target in "${TARGETS[@]}"; do
  echo "Installing for $target..."
  case "$target" in
    antigravity)
      copy_skill "$HOME/.gemini/config/skills/gitmcp"
      [[ $SKIP_MCP -eq 0 ]] && merge_json_mcp "$HOME/.gemini/config/mcp_config.json" "{\"url\":\"$GITMCP_URL\"}"
      ;;
    gemini)
      copy_skill "$HOME/.gemini/skills/gitmcp"
      [[ $SKIP_MCP -eq 0 ]] && merge_json_mcp "$HOME/.gemini/settings.json" "{\"httpUrl\":\"$GITMCP_URL\"}"
      ;;
    claude)
      copy_skill "$HOME/.claude/skills/gitmcp"
      if [[ $SKIP_MCP -eq 0 ]]; then
        if command -v claude >/dev/null 2>&1; then
          claude mcp add --transport http -s user gitmcp "$GITMCP_URL" >/dev/null 2>&1 || true
          echo "  [MCP]   Registered gitmcp via 'claude mcp add -s user'"
        else
          merge_json_mcp "$HOME/.claude.json" "{\"type\":\"http\",\"url\":\"$GITMCP_URL\"}"
        fi
      fi
      ;;
    codex)
      copy_skill "$HOME/.agents/skills/gitmcp"
      [[ $SKIP_MCP -eq 0 ]] && merge_codex_toml "$HOME/.codex/config.toml"
      ;;
    cursor)
      copy_skill "$HOME/.cursor/skills/gitmcp"
      [[ $SKIP_MCP -eq 0 ]] && merge_json_mcp "$HOME/.cursor/mcp.json" "{\"url\":\"$GITMCP_URL\"}"
      ;;
    windsurf)
      copy_skill "$HOME/.agents/skills/gitmcp"
      [[ $SKIP_MCP -eq 0 ]] && merge_json_mcp "$HOME/.codeium/windsurf/mcp_config.json" "{\"serverUrl\":\"$GITMCP_URL\"}"
      ;;
    *)
      echo "Unknown target: $target" >&2
      exit 1
      ;;
  esac
done

echo ""
echo "Done! Start a new session in your AI tool(s) to use /gitmcp (or \$gitmcp in Codex)."
