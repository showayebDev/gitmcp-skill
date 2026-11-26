# Universal `/gitmcp` Skill + GitMCP Installation Guide (All AI Clients)

This bundle allows you to install and use the **`/gitmcp` (`$gitmcp`)** skill and **GitMCP** (`https://gitmcp.io/docs`) across **Google Antigravity**, **Gemini CLI**, **Claude CLI (Claude Code)**, **OpenAI Codex**, **Claude Web (`claude.ai`)**, **ChatGPT Web (`chatgpt.com`)**, **Cursor**, **Windsurf**, **VS Code Copilot**, and **Claude Desktop**.

---

## Easiest Way (Automated Setup for All Local CLI/IDE Agents)

Run the installer script from the root of this repository:

- **Windows (PowerShell):**
  ```powershell
  .\scripts\install.ps1 -Targets all
  ```
- **macOS / Linux (Bash):**
  ```bash
  bash ./scripts/install.sh all
  ```

This automatically installs the `gitmcp` skill and configures the `https://gitmcp.io/docs` MCP server for **Antigravity**, **Gemini CLI**, **Claude Code**, and **OpenAI Codex** (you can also pass `cursor` or `windsurf`).

Or install the skill across detected agents with the universal Skills CLI (`skills.sh`):
```bash
npx skills add showayebDev/gitmcp-skill --skill gitmcp -g
```

---

## Platform-by-Platform Manual Setup

### 1. Google Antigravity
- **Install Skill:** Copy `gitmcp/` to:
  - **Windows:** `%USERPROFILE%\.gemini\config\skills\gitmcp\`
  - **macOS / Linux:** `~/.gemini/config/skills/gitmcp/`
- **Configure MCP:** Add under `"mcpServers"` in `~/.gemini/config/mcp_config.json` (see [`configs/antigravity.mcp_config.json`](./configs/antigravity.mcp_config.json)):
  ```json
  "gitmcp": {
    "url": "https://gitmcp.io/docs"
  }
  ```
- **Use:** Start a new conversation and type `/gitmcp <your question>`.

---

### 2. Gemini CLI (`gemini`)
- **Install Skill:**
  ```bash
  gemini skills install https://github.com/showayebDev/gitmcp-skill --path gitmcp
  ```
  *(Or manually copy `gitmcp/` to `~/.gemini/skills/gitmcp/` for global use or `.gemini/skills/gitmcp/` for workspace-only use.)*
- **Add GitMCP MCP Server:**
  ```bash
  gemini mcp add -t http -s user gitmcp https://gitmcp.io/docs
  ```
  *(Or add `"gitmcp": { "httpUrl": "https://gitmcp.io/docs" }` under `"mcpServers"` in `~/.gemini/settings.json` — see [`configs/gemini-cli.settings.json`](./configs/gemini-cli.settings.json).)*
- **Verify & Use:** Run `/skills reload` and `/mcp` inside `gemini`, then invoke `/gitmcp <your question>`.

---

### 3. Claude CLI / Claude Code (`claude`)
- **Option A — Install as a Native Plugin (Skill + MCP together):**
  Inside `claude`, run:
  ```text
  /plugin marketplace add showayebDev/gitmcp-skill
  /plugin install gitmcp@gitmcp-skill
  ```
- **Option B — Install Skill + MCP Separately:**
  - Copy `gitmcp/` to `~/.claude/skills/gitmcp/` (or run `npx skills add showayebDev/gitmcp-skill --skill gitmcp -a claude-code -g`).
  - Add the MCP server:
    ```bash
    claude mcp add --transport http -s user gitmcp https://gitmcp.io/docs
    ```
    *(Or use [`configs/claude-code.mcp.json`](./configs/claude-code.mcp.json) as `.mcp.json` in a project root.)*
- **Verify & Use:** Run `claude mcp list` or `/mcp` in-session, then invoke `/gitmcp <your question>`.

---

### 4. OpenAI Codex (CLI / Desktop App / IDE)
- **Install Skill:**
  In Codex, run:
  ```text
  $skill-installer install the gitmcp skill from GitHub repository showayebDev/gitmcp-skill path gitmcp
  ```
  *(Or manually copy `gitmcp/` to `~/.agents/skills/gitmcp/`.)*
- **Add GitMCP MCP Server:**
  ```bash
  codex mcp add gitmcp --url https://gitmcp.io/docs
  ```
  *(Or append the snippet from [`configs/codex.config.toml`](./configs/codex.config.toml) to `~/.codex/config.toml`:)*
  ```toml
  [mcp_servers.gitmcp]
  url = "https://gitmcp.io/docs"
  ```
- **Verify & Use:** Restart Codex, verify with `/mcp`, and invoke `$gitmcp <your question>`.

---

### 5. Claude Web (`claude.ai`)
To get the full experience on Claude Web, set up both the Skill and the Custom Connector:

1. **Upload the Skill (`.zip`):**
   - In `claude.ai`, ensure **Settings > Capabilities > Code execution and file creation** is enabled.
   - Open **Customize > Skills** (or **Settings > Capabilities > Skills**) and click **Add skill / Upload skill**.
   - Upload [`dist/gitmcp.zip`](./dist/gitmcp.zip) from this repository and toggle the `gitmcp` skill **ON**.
2. **Add GitMCP Custom Connector (Live MCP Tools):**
   - Go to **Customize > Connectors** (or **Settings > Connectors**) and click **+ Add > Add custom connector**.
   - **Name:** `GitMCP`
   - **Remote MCP server URL:** `https://gitmcp.io/docs`
   - Save and enable the `GitMCP` connector in your chat.
3. **Free Plan / No-Connector Alternative (Claude Projects):**
   - Create a **Claude Project** and paste the prompt from [`configs/web-system-prompt.md`](./configs/web-system-prompt.md) into **Project Instructions**.

---

### 6. ChatGPT Web (`chatgpt.com`)
Follow these steps for ChatGPT Web:

1. **Upload the Skill (`.zip`):**
   - Open **Plugins / Skills > Create > Upload a skill** (or upload folder) from the sidebar.
   - Upload [`dist/gitmcp.zip`](./dist/gitmcp.zip) (or the `gitmcp/` folder).
   - Mention `@gitmcp` in chat or let ChatGPT auto-trigger it when asking about libraries or repos.
2. **Add GitMCP MCP Connector (Developer Mode):**
   - Go to **Settings > Security and sign-in** (or **Advanced**) and turn **Developer Mode** ON.
   - Open **Apps / Connectors > + Add custom MCP server**:
     - **Name:** `GitMCP`
     - **Connection URL:** `https://gitmcp.io/docs`
     - **Authentication:** `No authentication`
   - Save and enable `@GitMCP` (or select it from Tools) in a new chat.
3. **Standard / Free Plan Alternative (Custom Instructions / Custom GPT):**
   - Paste [`configs/web-system-prompt.md`](./configs/web-system-prompt.md) into **Customize ChatGPT (Custom Instructions)** or a **Custom GPT**'s Instructions (with Web Search enabled).

---

### 7. Other MCP Clients
- **Cursor:** Copy `gitmcp/` to `~/.cursor/skills/gitmcp/` and add `"gitmcp": { "url": "https://gitmcp.io/docs" }` to `~/.cursor/mcp.json`.
- **Windsurf:** Copy `gitmcp/` to `~/.agents/skills/gitmcp/` and add `"gitmcp": { "serverUrl": "https://gitmcp.io/docs" }` to `~/.codeium/windsurf/mcp_config.json`.
- **Claude Desktop:** Add [`configs/claude-desktop.config.json`](./configs/claude-desktop.config.json) to `claude_desktop_config.json`.
- **VS Code (Copilot):** Add [`configs/vscode.mcp.json`](./configs/vscode.mcp.json) to `.vscode/mcp.json`.

---

### 8. Agent-Assisted Setup on Any New Device
Open any coding agent in this folder (or share `gitmcp/SKILL.md` and `gitmcp/references/platform-setup.md`) and prompt:
> **"Read `gitmcp/SKILL.md` and `gitmcp/references/platform-setup.md`, install the `gitmcp` skill and configure the `gitmcp` MCP server (`https://gitmcp.io/docs`) for the AI tools on this device, then verify the setup."**
