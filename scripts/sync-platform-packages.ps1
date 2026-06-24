$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "axin-personal-ip-illustrations"
$claudeSkillRoot = Join-Path $repoRoot ".claude-plugin\skills"
$claudeSkillTarget = Join-Path $claudeSkillRoot "axin-personal-ip-illustrations"

New-Item -ItemType Directory -Force -Path $claudeSkillRoot | Out-Null

if (Test-Path -LiteralPath $claudeSkillTarget) {
  Remove-Item -LiteralPath $claudeSkillTarget -Recurse -Force
}

Copy-Item -LiteralPath $source -Destination $claudeSkillRoot -Recurse -Force

Write-Host "Synced Claude plugin skill snapshot to $claudeSkillTarget"

