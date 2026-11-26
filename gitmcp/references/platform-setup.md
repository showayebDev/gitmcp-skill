# GitMCP Multi-Platform Setup Reference

This reference contains exact skill paths, MCP configurations, and web setup steps for every supported AI client.

Remote GitMCP MCP Endpoint (dynamic multi-repo): `https://gitmcp.io/docs`
Repo-pinned GitMCP Endpoint (optional): `https://gitmcp.io/{owner}/{repo}`

---

## 1. Universal CLI (`npx skills`)

Installs `gitmcp/SKILL.md` across detected agents (Antigravity, Gemini CLI, Claude Code, Codex, Cursor, etc.):
```bash
npx skills add showayebDev/gitmcp-skill --skill gitmcp -g
```
Target a specific agent with `-a` (e.g., `-a claude-code`, `-a gemini-cli`, `-a codex`, `-a antigravity`).
Note: You still need to register the `gitmcp` MCP server in each agent (see sections below).

---

## 2. Google Antigravity

- **Skill path (Global)**:
  - Windows: `%USERPROFILE%\.gemini\config\skills\gitmcp\SKILL.md`
  - macOS / Linux: `~/.gemini/config/skills/gitmcp/SKILL.md`
  - (Also copy `agents/` and `references/` alongside `SKILL.md`.)
- **MCP config** (`~/.gemini/config/mcp_config.json`):
  ```json
  {
    "mcpServers": {
      "gitmcp": {
        "url": "https://gitmcp.io/docs"
      }
    }
  }
  ```
- **Use**: Open a new conversation and type `/gitmcp <library or question>`.

---

## 3. Gemini CLI (`gemini`)

- **Install Skill**:
  ```bash
  gemini skills install https://github.com/showayebDev/gitmcp-skill --path gitmcp
  ```
  Or copy `gitmcp/` manually to `~/.gemini/skills/gitmcp/` (global) or `.gemini/skills/gitmcp/` (workspace).
  (Gemini CLI also discovers `~/.agents/skills/gitmcp/` and `.agents/skills/gitmcp/`.)
- **Add GitMCP MCP Server**:
  ```bash
  gemini mcp add -t http -s user gitmcp https://gitmcp.io/docs
  ```
  Or edit `~/.gemini/settings.json` (global) / `.gemini/settings.json` (project):
  ```json
  {
    "mcpServers": {
      "gitmcp": {
        "httpUrl": "https://gitmcp.io/docs"
      }
    }
  }
  ```
- **Verify & Use**: Run `/skills reload` or `/skills list` and `/mcp` inside `gemini`.

---

## 4. Claude Code / Claude CLI (`claude`)

- **Option A — Plugin Marketplace (installs Skill + MCP together)**:
  Inside `claude`:
  ```text
  /plugin marketplace add showayebDev/gitmcp-skill
  /plugin install gitmcp@gitmcp-skill
  ```
- **Option B — Skill + CLI MCP**:
  Copy `gitmcp/` to `~/.claude/skills/gitmcp/` (global) or `.claude/skills/gitmcp/` (project), or run `npx skills add showayebDev/gitmcp-skill --skill gitmcp -a claude-code -g`.
  Then add the MCP server:
  ```bash
  claude mcp add --transport http -s user gitmcp https://gitmcp.io/docs
  ```
  Or place `.mcp.json` in a project root:
  ```json
  {
    "mcpServers": {
      "gitmcp": {
        "type": "http",
        "url": "https://gitmcp.io/docs"
      }
    }
  }
  ```
- **Verify & Use**: Run `claude mcp list` or `/mcp` in-session, then invoke `/gitmcp <question>`.

---

## 5. OpenAI Codex (CLI / Desktop App / IDE)

- **Install Skill**:
  - In Codex, invoke:
    ```text
    $skill-installer install the gitmcp skill from GitHub repository showayebDev/gitmcp-skill path gitmcp
    ```
  - Or copy `gitmcp/` manually to `~/.agents/skills/gitmcp/` (global) or `.agents/skills/gitmcp/` (project), or run `npx skills add showayebDev/gitmcp-skill --skill gitmcp -a codex -g`.
- **Add GitMCP MCP Server**:
  ```bash
  codex mcp add gitmcp --url https://gitmcp.io/docs
  ```
  Or edit `~/.codex/config.toml` (global) / `.codex/config.toml` (trusted project):
  ```toml
  [mcp_servers.gitmcp]
  url = "https://gitmcp.io/docs"
  ```
- **Verify & Use**: Restart Codex, check `/mcp`, and invoke `$gitmcp <question>`.

---

## 6. Claude Web (`claude.ai`)

> Note: Web chats run in an ephemeral sandbox and cannot persistently install skills from a chat prompt.

1. **Upload the Skill (Pro / Max / Team / Enterprise with Code execution enabled)**:
   - Ensure **Settings > Capabilities > Code execution and file creation** is enabled.
   - Open **Customize > Skills** (or **Settings > Capabilities > Skills**).
   - Click **Add skill / Upload skill** and upload `dist/gitmcp.zip` from this repo.
   - Toggle the `gitmcp` skill **ON**.
2. **Connect GitMCP as a Custom Connector (MCP)**:
   - Go to **Customize > Connectors** (or **Settings > Connectors**).
   - Click **+ Add** -> **Add custom connector**.
   - **Name**: `GitMCP`
   - **Remote MCP server URL**: `https://gitmcp.io/docs`
   - Enable the `GitMCP` connector in your chat.
3. **Free Plan / No-Connector Alternative (Claude Projects)**:
   - Click **Projects** in the left sidebar, create a Project, and paste `configs/web-system-prompt.md` into **Project Instructions**.

---

## 7. ChatGPT Web (`chatgpt.com`)

1. **Upload the Skill (Supported plans with Skills enabled)**:
   - Open **Plugins / Skills** in the sidebar -> **Create** -> **Upload a skill** (or upload folder).
   - Select `dist/gitmcp.zip` (or the `gitmcp/` folder).
   - Once registered, mention `@gitmcp` or let ChatGPT auto-trigger it.
2. **Connect GitMCP via Developer Mode MCP Connector**:
   - Go to **Settings > Security and sign-in** (or **Advanced**) and toggle **Developer Mode** ON.
   - Open **Apps / Connectors** -> **+ Add custom MCP server**.
   - **Name**: `GitMCP`
   - **Connection URL**: `https://gitmcp.io/docs`
   - **Authentication**: `No authentication`
   - Save, enable in your chat (`@GitMCP` / Tools), and prompt normally.
3. **Free / Standard Plan Alternative (Custom Instructions / Custom GPT)**:
   - Paste `configs/web-system-prompt.md` into **Customize ChatGPT (Custom Instructions)** or a **Custom GPT**'s Instructions (with Web Search enabled).

---

## 8. Other MCP Clients

- **Cursor** (`~/.cursor/mcp.json`, skill in `~/.cursor/skills/gitmcp/` or `~/.agents/skills/gitmcp/`):
  ```json
  { "mcpServers": { "gitmcp": { "url": "https://gitmcp.io/docs" } } }
  ```
- **Windsurf** (`~/.codeium/windsurf/mcp_config.json`):
  ```json
  { "mcpServers": { "gitmcp": { "serverUrl": "https://gitmcp.io/docs" } } }
  ```
- **Claude Desktop** (`claude_desktop_config.json`, Stdio bridge):
  ```json
  {
    "mcpServers": {
      "gitmcp": {
        "command": "npx",
        "args": ["-y", "mcp-remote", "https://gitmcp.io/docs"]
      }
    }
  }
  ```
- **VS Code (GitHub Copilot)** (`.vscode/mcp.json`):
  ```json
  { "servers": { "gitmcp": { "type": "http", "url": "https://gitmcp.io/docs" } } }
  ```
