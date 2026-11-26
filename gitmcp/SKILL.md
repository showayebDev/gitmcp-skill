---
name: gitmcp
description: >-
  Fetch the latest documentation, source code, and llms.txt directly from any
  public GitHub repository or official docs URL using the GitMCP MCP server.
  Use when invoked with /gitmcp, $gitmcp, or when the user asks for up-to-date
  library, framework, SDK, or repository documentation and code examples.
---

# /gitmcp — Universal Live GitHub Docs & Code Lookup via GitMCP

Use the `gitmcp` remote MCP server (`https://gitmcp.io/docs`) to ground answers
and generated code in the latest documentation, `llms.txt`, and source code from
public GitHub repositories.

Works across **Google Antigravity**, **Gemini CLI**, **Claude Code (CLI)**,
**OpenAI Codex**, **Claude Web**, **ChatGPT Web**, Cursor, Windsurf, VS Code,
and any MCP / Agent Skills compatible client.

## Workflow

### 1. Resolve Target Repository (`owner/repo`) or Docs URL
From the user's prompt, identify the library, framework, or GitHub repository:
- If the user provides `owner/repo` or a GitHub URL, extract `owner` and `repo`.
- If the user names a library without `owner/repo`, call `match_common_libs_owner_repo_mapping` on the `gitmcp` MCP server with `library`.
- If no mapping is found (for example, `elysia` -> `elysiajs/elysia` and `elysiajs/documentation`), use the verified official `owner/repo` (or check via web search if available — never guess an unfamiliar `owner/repo`).

### 2. Fetch Latest Documentation & Code via `gitmcp` MCP Tools
Invoke the tools exposed by the `gitmcp` MCP server (depending on the client, tools may appear directly by name, prefixed like `mcp__gitmcp__*`, or via `call_mcp_tool` with `ServerName: "gitmcp"`):
1. **`search_generic_documentation`** (`owner`, `repo`, `query`):
   - Start here for targeted concepts (routing, plugins, auth, config, hooks, etc.).
   - Some projects keep docs in a separate repo (e.g., `elysiajs/documentation` vs `elysiajs/elysia`). If the main repo returns only a minimal README, also query the dedicated docs repo or its `llms.txt`.
2. **`fetch_generic_documentation`** (`owner`, `repo`):
   - Fetch the repository's primary documentation, `llms.txt`, or `README.md`.
3. **`search_generic_code`** (`owner`, `repo`, `query`, optional `page`):
   - Verify exact API signatures, exported symbols, TypeScript types, or recent code changes directly in the repository source.
4. **`fetch_generic_url_content`** (`url`):
   - Read absolute URLs referenced inside fetched docs (such as `https://elysiajs.com/llms.txt` or linked markdown docs).

### 3. Answer Grounded in Retrieved Data
- Prefer `gitmcp` results over pre-training memory for imports, API signatures, CLI flags, and configuration formats.
- Cite the GitHub repository (`owner/repo`) or official URL you queried.

### 4. If `gitmcp` MCP Tools Are Not Available in This Session
- **Web Clients (Claude Web / ChatGPT Web) without MCP connected**:
  - If web browsing/fetch is available, fetch `https://gitmcp.io/{owner}/{repo}/llms.txt` or `https://raw.githubusercontent.com/{owner}/{repo}/main/README.md` as a temporary fallback, and show the user how to connect the `https://gitmcp.io/docs` connector in settings (see `references/platform-setup.md`).
- **CLI / IDE Agents (Antigravity, Gemini CLI, Claude Code, Codex, Cursor, etc.)**:
  - Follow **Bootstrap & Setup on a New Device** below (and `references/platform-setup.md` for exact file paths and commands), then ask the user to start a new session or reload MCP servers.

---

## Bootstrap & Setup on a New Device (For AI Agents)

When a user asks you to install this skill and configure GitMCP on their machine, detect which AI client(s) they use (or install for the requested client) using the exact paths in `references/platform-setup.md`:

1. **Install `SKILL.md` (and `references/`, `agents/`)**:
   - **Universal (Skills CLI)**: `npx skills add showayebDev/gitmcp-skill --skill gitmcp -g`
   - **Google Antigravity**: `~/.gemini/config/skills/gitmcp/`
   - **Gemini CLI**: `~/.gemini/skills/gitmcp/` (or `~/.agents/skills/gitmcp/`)
   - **Claude Code (CLI)**: `~/.claude/skills/gitmcp/` (or `~/.agents/skills/gitmcp/`)
   - **OpenAI Codex**: `~/.agents/skills/gitmcp/` (or `~/.codex/skills/gitmcp/`)
   - **Workspace / Project-level (shared)**: `.agents/skills/gitmcp/`
   - **Claude Web / ChatGPT Web**: Upload `dist/gitmcp.zip` in the Skills UI (see `references/platform-setup.md`).
2. **Configure the GitMCP MCP Server (`https://gitmcp.io/docs`)**:
   - **Antigravity**: `~/.gemini/config/mcp_config.json` -> `"gitmcp": { "url": "https://gitmcp.io/docs" }`
   - **Gemini CLI**: `gemini mcp add -t http -s user gitmcp https://gitmcp.io/docs` (or `~/.gemini/settings.json` with `"httpUrl"`)
   - **Claude Code (CLI)**: `claude mcp add --transport http -s user gitmcp https://gitmcp.io/docs` (or `.mcp.json` with `"type": "http"`)
   - **OpenAI Codex**: `codex mcp add gitmcp --url https://gitmcp.io/docs` (or `~/.codex/config.toml` `[mcp_servers.gitmcp]`)
   - **Claude Web / ChatGPT Web**: Add custom MCP connector `https://gitmcp.io/docs` in Connectors / Developer Mode.
3. **Verify**:
   - Validate modified JSON/TOML files, verify `https://gitmcp.io/docs` responds, and tell the user to start a new chat / reload skills & MCP servers.
