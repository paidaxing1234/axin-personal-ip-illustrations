param(
  [string]$HermesHome = $env:HERMES_HOME
)

$ErrorActionPreference = "Stop"

if (-not $HermesHome) {
  $HermesHome = Join-Path $env:LOCALAPPDATA "hermes"
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillSource = Join-Path $repoRoot "axin-personal-ip-illustrations"
$targetRoot = Join-Path $HermesHome "skills\creative"
$skillTarget = Join-Path $targetRoot "axin-personal-ip-illustrations"

if (-not (Test-Path -LiteralPath (Join-Path $skillSource "SKILL.md"))) {
  throw "SKILL.md not found at $skillSource"
}

New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

if (Test-Path -LiteralPath $skillTarget) {
  Remove-Item -LiteralPath $skillTarget -Recurse -Force
}

Copy-Item -LiteralPath $skillSource -Destination $targetRoot -Recurse -Force

Write-Host "Installed axin-personal-ip-illustrations to Hermes: $skillTarget"
Write-Host "Run '/reload-skills' in Hermes or start a new Hermes session if needed."

