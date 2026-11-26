$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$SkillDir = Join-Path $RepoRoot "gitmcp"
$DistDir  = Join-Path $RepoRoot "dist"
$ZipPath  = Join-Path $DistDir "gitmcp.zip"

if (-not (Test-Path (Join-Path $SkillDir "SKILL.md"))) {
    throw "Missing gitmcp/SKILL.md at $SkillDir"
}

New-Item -ItemType Directory -Force -Path $DistDir | Out-Null
if (Test-Path $ZipPath) {
    Remove-Item -Force $ZipPath
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$zip = [System.IO.Compression.ZipFile]::Open($ZipPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    $files = Get-ChildItem -Path $SkillDir -Recurse -File
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($RepoRoot.Length + 1).Replace('\', '/')
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zip,
            $file.FullName,
            $relative,
            [System.IO.Compression.CompressionLevel]::Optimal
        ) | Out-Null
    }
}
finally {
    $zip.Dispose()
}

Write-Host "Created $ZipPath (ready for Claude Web and ChatGPT Web upload)."
