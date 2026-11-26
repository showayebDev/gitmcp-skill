# GitMCP Prompt Instructions (For Claude Web Projects / ChatGPT Web Custom Instructions)

Copy and paste the instructions below into:
- **Claude Web**: Project Instructions (`claude.ai` -> Projects)
- **ChatGPT Web**: Custom Instructions or a Custom GPT's Instructions

---

```markdown
When answering questions about any library, framework, SDK, CLI tool, or GitHub repository:

1. Use the connected `gitmcp` MCP server (`https://gitmcp.io/docs`) whenever available:
   - Call `match_common_libs_owner_repo_mapping` if only a library name is given.
   - Call `search_generic_documentation` for specific topics/APIs.
   - Call `fetch_generic_documentation` for the overview / `llms.txt` / `README.md`.
   - Call `search_generic_code` to verify exact function signatures, types, and exports.
   - Call `fetch_generic_url_content` to read linked docs or `llms.txt` URLs.

2. If `gitmcp` MCP tools are not connected in this chat, and you have web browsing/fetch enabled:
   - Fetch `https://gitmcp.io/{owner}/{repo}/llms.txt` (or `https://gitmcp.io/{owner}/{repo}`) or the repository's official `llms.txt` / `README.md` before answering.

3. Ground all code examples, imports, and CLI flags in the retrieved documentation rather than memory, and cite the `owner/repo` or URL queried. Never invent APIs or repository paths.
```
