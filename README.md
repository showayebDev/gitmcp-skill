# gitmcp-skill

Universal **`/gitmcp` (`$gitmcp`) Agent Skill** + **GitMCP** (`https://gitmcp.io/docs`) setup bundle for **all major AI coding agents and web chats**:

- **Google Antigravity**
- **Gemini CLI**
- **Claude Code / Claude CLI**
- **OpenAI Codex** (CLI, Desktop App, IDE)
- **Claude Web** (`claude.ai` — Skills ZIP + Custom Connector + Projects)
- **ChatGPT Web** (`chatgpt.com` — Skills ZIP + Developer Mode MCP + Custom Instructions)
- **Cursor, Windsurf, VS Code Copilot, Claude Desktop**

---

## What This Skill Does

AI models often hallucinate outdated APIs, deprecated flags, or non-existent imports because their training data is frozen in time. **`gitmcp`** solves this by connecting your AI directly to live, up-to-date documentation and source code from any public GitHub repository or official docs URL via **[GitMCP](https://gitmcp.io)** (`https://gitmcp.io/docs`) — with **no paid API keys or rate-limit paywalls**.

When invoked (via `/gitmcp`, `$gitmcp`, `@gitmcp`, or automatically when you ask about a library/repo), this skill teaches the AI to follow a structured workflow:

1. **Resolve the Repository:** Automatically maps a library or framework name (or GitHub URL) to its official `owner/repo` using `match_common_libs_owner_repo_mapping`.
2. **Search & Read Latest Docs:** Queries `search_generic_documentation` and `fetch_generic_documentation` to pull the project's latest `llms.txt`, `README.md`, and docs (including separate docs repos when needed).
3. **Verify Real Source Code:** Uses `search_generic_code` to inspect actual TypeScript/Python/JS/etc. exports, function signatures, and recent repository changes directly in the codebase.
4. **Follow Referenced Doc URLs:** Fetches linked markdown docs or external `llms.txt` files via `fetch_generic_url_content` (and falls back to direct `https://gitmcp.io/{owner}/{repo}/llms.txt` web fetch in web chats if MCP is not connected).
5. **Ground Every Answer:** Forces the AI to base code examples, imports, and CLI flags on the fetched source of truth and cite the repository or URL queried.
6. **Self-Bootstrap on New Devices:** If `gitmcp` isn't installed yet on a machine, an AI agent can read `SKILL.md` + `references/platform-setup.md` and install the skill and MCP config for you automatically.

### Example Prompts
```text
/gitmcp How do I set up middleware and WebSockets in elysiajs/elysia?
/gitmcp Check the latest Next.js App Router caching APIs in vercel/next.js
$gitmcp Verify the exact signature of createAgent in langchain-ai/langchainjs
```

---

## Quick Install (Skill + MCP Behavior Explained)

| Install Method | Installs `SKILL.md`? | Configures `mcp_config.json` / MCP Server? | Notes |
| :--- | :---: | :---: | :--- |
| **`npx skills add showayebDev/gitmcp-skill`** | Yes | **No** | Opens an interactive agent checklist; you must add the MCP server afterward (see below). |
| **AI-Assisted Setup (from GitHub URL)** | Yes | **Yes** | Ask your AI to read `SKILL.md` & `references/platform-setup.md` and configure both. |
| **Installer Script (`install.ps1` / `install.sh`)** | Yes | **Yes** | Installs `gitmcp` and merges `https://gitmcp.io/docs` into each selected agent's MCP config. |
| **Claude Code Plugin (`/plugin marketplace add`)** | Yes | **Yes** | [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json) registers both the skill and MCP together. |

### Option 1: Universal Skills CLI (`npx skills`) — Interactive Agent Picker
Run without agent flags to pick from detected agents (Antigravity, Gemini CLI, Claude Code, Codex, Cursor, etc.), or install globally directly:
```bash
# Interactive multi-select checklist:
npx skills add showayebDev/gitmcp-skill

# Or install globally right away:
npx skills add showayebDev/gitmcp-skill --skill gitmcp -g
```
> **Important:** `npx skills add` only installs the skill files (`SKILL.md`, `agents/`, `references/`)—it does **not** edit `mcp_config.json`, `settings.json`, or `config.toml`. After running `npx`, complete the MCP setup by either:
> - Asking your AI: *"Check my installed `gitmcp` skill and configure the `gitmcp` MCP server (`https://gitmcp.io/docs`) for this client."*
> - Running your client's `mcp add` command or copying the snippet from [`configs/`](./configs) (see the table below).

### Option 2: AI-Assisted Setup from GitHub (Local CLI / IDE Agents Only)
Open any **local** AI coding agent (Antigravity, Gemini CLI, Claude Code, Codex, Cursor) and prompt:
> *"Read `https://github.com/showayebDev/gitmcp-skill` (`gitmcp/SKILL.md` and `gitmcp/references/platform-setup.md`), install the `gitmcp` skill, and configure the `gitmcp` MCP server (`https://gitmcp.io/docs`) for this AI client."*

Because `SKILL.md` includes self-bootstrap instructions, a local agent will install the skill **and** automatically add `"gitmcp"` to `mcp_config.json` (or `settings.json` / `.claude.json` / `config.toml`).

> **Note for Web Chats (`claude.ai` / `chatgpt.com`):** Web chats run in an ephemeral sandbox and **cannot** install skills or MCP connectors from a chat prompt.
> - **Claude Web Free Plan:** Open **Projects** in the left sidebar -> create a Project -> paste [`configs/web-system-prompt.md`](./configs/web-system-prompt.md) into **Project Instructions**.
> - **Claude Web / ChatGPT Web Paid Plans:** Upload [`dist/gitmcp.zip`](./dist/gitmcp.zip) in **Skills** and add `https://gitmcp.io/docs` in **Connectors** (see the table below).

### Option 3: Automated Installer Script (Configures Skill + MCP Together)
- **Windows (PowerShell)**:
  ```powershell
  .\scripts\install.ps1 -Targets all
  # Or choose specific targets:
  .\scripts\install.ps1 -Targets antigravity,gemini,claude,codex
  ```
- **macOS / Linux (Bash)**:
  ```bash
  bash ./scripts/install.sh all
  # Or choose specific targets:
  bash ./scripts/install.sh antigravity gemini claude codex
  ```

---

## Platform-by-Platform Setup

| Platform | Skill Install | GitMCP MCP Server Setup | Invoke |
| :--- | :--- | :--- | :--- |
| **Google Antigravity** | `~/.gemini/config/skills/gitmcp/` | `~/.gemini/config/mcp_config.json` ([example](./configs/antigravity.mcp_config.json)) | `/gitmcp <query>` |
| **Gemini CLI** | `gemini skills install https://github.com/showayebDev/gitmcp-skill --path gitmcp` | `gemini mcp add -t http -s user gitmcp https://gitmcp.io/docs` | `/gitmcp <query>` |
| **Claude Code (CLI)** | `/plugin marketplace add showayebDev/gitmcp-skill` then `/plugin install gitmcp@gitmcp-skill` | Included in plugin, or `claude mcp add --transport http -s user gitmcp https://gitmcp.io/docs` | `/gitmcp <query>` |
| **OpenAI Codex** | `$skill-installer` from `showayebDev/gitmcp-skill` (`gitmcp`) or `~/.agents/skills/gitmcp/` | `codex mcp add gitmcp --url https://gitmcp.io/docs` ([TOML](./configs/codex.config.toml)) | `$gitmcp <query>` |
| **Claude Web (`claude.ai`)** | Upload [`dist/gitmcp.zip`](./dist/gitmcp.zip) in **Customize > Skills** | **Customize > Connectors > + Add custom connector**: `https://gitmcp.io/docs` | Ask normally or use Projects prompt |
| **ChatGPT Web (`chatgpt.com`)** | Upload [`dist/gitmcp.zip`](./dist/gitmcp.zip) in **Plugins / Skills > Create** | Enable **Developer Mode** -> **Apps/Connectors**: `https://gitmcp.io/docs` | `@gitmcp` or `@GitMCP` |

> **Free Web Plans (No MCP / Skills Upload)?**
> Copy [`configs/web-system-prompt.md`](./configs/web-system-prompt.md) into **Claude Projects** or **ChatGPT Custom Instructions / Custom GPT**.

---

## Repository Contents

- [`gitmcp/SKILL.md`](./gitmcp/SKILL.md) — Cross-platform Agent Skill instructions
- [`gitmcp/agents/openai.yaml`](./gitmcp/agents/openai.yaml) — OpenAI Codex & ChatGPT UI metadata
- [`gitmcp/references/platform-setup.md`](./gitmcp/references/platform-setup.md) — Detailed setup reference for all agents
- [`dist/gitmcp.zip`](./dist/gitmcp.zip) — Pre-built ZIP archive ready to upload to **Claude Web** and **ChatGPT Web**
- [`.claude-plugin/`](./.claude-plugin/plugin.json) & [`.mcp.json`](./.mcp.json) — Native **Claude Code** plugin, marketplace, and MCP manifest
- [`configs/`](./configs) — Ready-to-copy MCP config snippets & web system prompt
- [`scripts/`](./scripts) — Installer (`install.ps1` / `install.sh`) and ZIP packager (`build-zip.ps1` / `build-zip.sh`)
- [`INSTALL.md`](./INSTALL.md) — Step-by-step installation guide for all AI clients
