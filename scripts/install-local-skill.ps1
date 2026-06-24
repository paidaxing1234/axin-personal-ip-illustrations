param(
  [string]$CodexHome = "$env:USERPROFILE\.codex"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillSource = Join-Path $repoRoot "axin-personal-ip-illustrations"
$skillTargetRoot = Join-Path $CodexHome "skills"
$skillTarget = Join-Path $skillTargetRoot "axin-personal-ip-illustrations"

if (-not (Test-Path -LiteralPath (Join-Path $skillSource "SKILL.md"))) {
  throw "SKILL.md not found at $skillSource"
}

New-Item -ItemType Directory -Force -Path $skillTargetRoot | Out-Null

if (Test-Path -LiteralPath $skillTarget) {
  Remove-Item -LiteralPath $skillTarget -Recurse -Force
}

Copy-Item -LiteralPath $skillSource -Destination $skillTargetRoot -Recurse -Force

Write-Host "Installed axin-personal-ip-illustrations to $skillTarget"
Write-Host "Restart Codex if the skill does not appear immediately."

