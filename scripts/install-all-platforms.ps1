$ErrorActionPreference = "Stop"

& (Join-Path $PSScriptRoot "sync-platform-packages.ps1")
& (Join-Path $PSScriptRoot "install-local-skill.ps1")
& (Join-Path $PSScriptRoot "install-hermes-skill.ps1")

Write-Host "Installed Codex and Hermes copies. Claude/Cursor/Windsurf/Cline use repo files directly."

