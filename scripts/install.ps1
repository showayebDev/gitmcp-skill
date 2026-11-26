param(
    [ValidateSet("all", "antigravity", "gemini", "claude", "codex", "cursor", "windsurf")]
    [string[]]$Targets = @("all"),
    [switch]$SkipMcp
)

$ErrorActionPreference = "Stop"

$RepoRoot  = Split-Path -Parent $PSScriptRoot
$SkillSrc  = Join-Path $RepoRoot "gitmcp"
$GitMcpUrl = "https://gitmcp.io/docs"

if ($Targets -contains "all") {
    $Targets = @("antigravity", "gemini", "claude", "codex")
}

function Copy-SkillFolder {
    param([string]$DestDir)
    $parent = Split-Path -Parent $DestDir
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    if (Test-Path $DestDir) {
        Remove-Item -Recurse -Force $DestDir
    }
    Copy-Item -Recurse -Force $SkillSrc $DestDir
    Write-Host "  [Skill] Installed to $DestDir"
}

function Merge-JsonMcpServer {
    param(
        [string]$ConfigPath,
        [hashtable]$ServerEntry
    )
    $parent = Split-Path -Parent $ConfigPath
    New-Item -ItemType Directory -Force -Path $parent | Out-Null

    if (Test-Path $ConfigPath) {
        $raw = Get-Content -Raw -Path $ConfigPath
        if ([string]::IsNullOrWhiteSpace($raw)) {
            $data = [pscustomobject]@{}
        } else {
            $data = $raw | ConvertFrom-Json
        }
    } else {
        $data = [pscustomobject]@{}
    }

    if (-not ($data.PSObject.Properties.Name -contains "mcpServers") -or $null -eq $data.mcpServers) {
        $data | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue ([pscustomobject]@{}) -Force
    }

    $entryObj = [pscustomobject]$ServerEntry
    $data.mcpServers | Add-Member -NotePropertyName "gitmcp" -NotePropertyValue $entryObj -Force

    $json = $data | ConvertTo-Json -Depth 16
    [System.IO.File]::WriteAllText($ConfigPath, $json + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  [MCP]   Configured gitmcp in $ConfigPath"
}

function Merge-CodexToml {
    param([string]$TomlPath)
    $parent = Split-Path -Parent $TomlPath
    New-Item -ItemType Directory -Force -Path $parent | Out-Null

    $block = "`n[mcp_servers.gitmcp]`nurl = `"$GitMcpUrl`"`n"
    if (Test-Path $TomlPath) {
        $existing = Get-Content -Raw -Path $TomlPath
        if ($existing -match '(?m)^\[mcp_servers\.gitmcp\]') {
            Write-Host "  [MCP]   gitmcp already present in $TomlPath"
            return
        }
        [System.IO.File]::AppendAllText($TomlPath, $block, [System.Text.UTF8Encoding]::new($false))
    } else {
        [System.IO.File]::WriteAllText($TomlPath, $block.TrimStart() , [System.Text.UTF8Encoding]::new($false))
    }
    Write-Host "  [MCP]   Configured gitmcp in $TomlPath"
}

foreach ($target in $Targets) {
    Write-Host "Installing for $target..."
    switch ($target) {
        "antigravity" {
            Copy-SkillFolder (Join-Path $HOME ".gemini\config\skills\gitmcp")
            if (-not $SkipMcp) {
                Merge-JsonMcpServer (Join-Path $HOME ".gemini\config\mcp_config.json") @{ url = $GitMcpUrl }
            }
        }
        "gemini" {
            Copy-SkillFolder (Join-Path $HOME ".gemini\skills\gitmcp")
            if (-not $SkipMcp) {
                Merge-JsonMcpServer (Join-Path $HOME ".gemini\settings.json") @{ httpUrl = $GitMcpUrl }
            }
        }
        "claude" {
            Copy-SkillFolder (Join-Path $HOME ".claude\skills\gitmcp")
            if (-not $SkipMcp) {
                $claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
                if ($claudeCmd) {
                    & claude mcp add --transport http -s user gitmcp $GitMcpUrl 2>$null | Out-Null
                    Write-Host "  [MCP]   Registered gitmcp via 'claude mcp add -s user'"
                } else {
                    Merge-JsonMcpServer (Join-Path $HOME ".claude.json") @{ type = "http"; url = $GitMcpUrl }
                }
            }
        }
        "codex" {
            Copy-SkillFolder (Join-Path $HOME ".agents\skills\gitmcp")
            if (-not $SkipMcp) {
                Merge-CodexToml (Join-Path $HOME ".codex\config.toml")
            }
        }
        "cursor" {
            Copy-SkillFolder (Join-Path $HOME ".cursor\skills\gitmcp")
            if (-not $SkipMcp) {
                Merge-JsonMcpServer (Join-Path $HOME ".cursor\mcp.json") @{ url = $GitMcpUrl }
            }
        }
        "windsurf" {
            Copy-SkillFolder (Join-Path $HOME ".agents\skills\gitmcp")
            if (-not $SkipMcp) {
                Merge-JsonMcpServer (Join-Path $HOME ".codeium\windsurf\mcp_config.json") @{ serverUrl = $GitMcpUrl }
            }
        }
    }
}

Write-Host "`nDone! Start a new session in your AI tool(s) to use /gitmcp (or `$gitmcp in Codex)."
