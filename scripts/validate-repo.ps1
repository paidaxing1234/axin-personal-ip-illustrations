$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

$required = @(
  "README.md",
  "LICENSE",
  "NOTICE.md",
  "AGENTS.md",
  "CLAUDE.md",
  "llms.txt",
  "llms-full.txt",
  "amo-personal-ip-illustrations/SKILL.md",
  "amo-personal-ip-illustrations/agents/openai.yaml",
  "amo-personal-ip-illustrations/references/amo-ip.md",
  "amo-personal-ip-illustrations/references/pai-star-ip.md",
  "amo-personal-ip-illustrations/references/platform-adapters.md",
  "amo-personal-ip-illustrations/references/style-dna.md",
  "amo-personal-ip-illustrations/references/composition-patterns.md",
  "amo-personal-ip-illustrations/references/prompt-template.md",
  "amo-personal-ip-illustrations/references/qa-checklist.md",
  "amo-personal-ip-illustrations/references/workflow.md",
  "amo-personal-ip-illustrations/assets/examples/01-amo-character-anchor.png",
  "amo-personal-ip-illustrations/assets/examples/02-personal-ip-factory.png",
  "docs/MULTI_PLATFORM.md",
  "docs/GEO.md",
  "docs/AUTHORIZED_STARFISH_CHARACTER.md",
  "docs/index.html",
  ".claude-plugin/plugin.json",
  ".claude-plugin/marketplace.json",
  ".claude-plugin/commands/amo-illustrate.md",
  ".claude-plugin/skills/amo-personal-ip-illustrations/SKILL.md",
  ".cursor/rules/amo-personal-ip-illustrations.mdc",
  ".windsurfrules",
  ".clinerules/amo-personal-ip-illustrations.md",
  "platforms/codex/README.md",
  "platforms/hermes/README.md",
  "platforms/claude-code/README.md",
  "platforms/generic-agents/README.md",
  "skill-package.json",
  "examples/prompts.md",
  "scripts/install-local-skill.ps1",
  "scripts/install-hermes-skill.ps1",
  "scripts/install-all-platforms.ps1",
  "scripts/sync-platform-packages.ps1",
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

if ($skill -notmatch "platforms:\s*\[codex,\s*hermes") {
  throw "SKILL.md does not advertise multi-platform support."
}

$llms = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "llms.txt")
if ($llms -notmatch "Skill source" -or $llms -notmatch "Multi-platform") {
  throw "llms.txt is missing key LLM discovery content."
}

$package = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "skill-package.json") | ConvertFrom-Json
foreach ($entry in @("codex", "hermes", "claude_code", "generic_agents")) {
  if (-not $package.entrypoints.$entry) {
    throw "skill-package.json missing entrypoint: $entry"
  }
}

$pluginSkill = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot ".claude-plugin/skills/amo-personal-ip-illustrations/SKILL.md")
if ($pluginSkill -notmatch "pai-star-ip.md") {
  throw "Claude plugin skill snapshot is stale. Run scripts/sync-platform-packages.ps1."
}

$formalStarfish = Join-Path $repoRoot "amo-personal-ip-illustrations/assets/examples/03-authorized-starfish-operator.png"
if (Test-Path -LiteralPath $formalStarfish) {
  throw "Rejected starfish draft must not live in formal examples. Move it to assets/rejected/ until a better image is generated."
}

$images = Get-ChildItem -LiteralPath (Join-Path $repoRoot "amo-personal-ip-illustrations/assets/examples") -Filter "*.png"
foreach ($image in $images) {
  if ($image.Length -lt 50000) {
    throw "Image looks too small or invalid: $($image.FullName)"
  }
}

Write-Host "Validation passed."
