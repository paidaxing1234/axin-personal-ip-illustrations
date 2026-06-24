$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

$required = @(
  "README.md",
  "LICENSE",
  "NOTICE.md",
  "amo-personal-ip-illustrations/SKILL.md",
  "amo-personal-ip-illustrations/agents/openai.yaml",
  "amo-personal-ip-illustrations/references/amo-ip.md",
  "amo-personal-ip-illustrations/references/style-dna.md",
  "amo-personal-ip-illustrations/references/composition-patterns.md",
  "amo-personal-ip-illustrations/references/prompt-template.md",
  "amo-personal-ip-illustrations/references/qa-checklist.md",
  "amo-personal-ip-illustrations/references/workflow.md",
  "amo-personal-ip-illustrations/assets/examples/01-amo-character-anchor.png",
  "amo-personal-ip-illustrations/assets/examples/02-personal-ip-factory.png",
  "examples/prompts.md",
  "scripts/install-local-skill.ps1",
  "scripts/new-illustration-brief.ps1"
)

$missing = @()
foreach ($path in $required) {
  $full = Join-Path $repoRoot $path
  if (-not (Test-Path -LiteralPath $full)) {
    $missing += $path
  }
}

if ($missing.Count -gt 0) {
  throw "Missing required files: $($missing -join ', ')"
}

$skill = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "amo-personal-ip-illustrations/SKILL.md")
if ($skill -notmatch "name:\s*amo-personal-ip-illustrations") {
  throw "SKILL.md metadata name is missing or incorrect."
}

$images = Get-ChildItem -LiteralPath (Join-Path $repoRoot "amo-personal-ip-illustrations/assets/examples") -Filter "*.png"
foreach ($image in $images) {
  if ($image.Length -lt 50000) {
    throw "Image looks too small or invalid: $($image.FullName)"
  }
}

Write-Host "Validation passed."

