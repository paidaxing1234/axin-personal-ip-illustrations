$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

$required = @(
  "README.md",
  "README.en.md",
  "LICENSE",
  "NOTICE.md",
  "AGENTS.md",
  "CLAUDE.md",
  "llms.txt",
  "llms-full.txt",
  "axin-personal-ip-illustrations/SKILL.md",
  "axin-personal-ip-illustrations/agents/openai.yaml",
  "axin-personal-ip-illustrations/references/axin-ip.md",
  "axin-personal-ip-illustrations/references/platform-adapters.md",
  "axin-personal-ip-illustrations/references/style-dna.md",
  "axin-personal-ip-illustrations/references/composition-patterns.md",
  "axin-personal-ip-illustrations/references/prompt-template.md",
  "axin-personal-ip-illustrations/references/qa-checklist.md",
  "axin-personal-ip-illustrations/references/workflow.md",
  "axin-personal-ip-illustrations/assets/examples/01-axin-character-anchor.png",
  "axin-personal-ip-illustrations/assets/examples/02-axin-content-workbench.png",
  "axin-personal-ip-illustrations/assets/examples/03-axin-bilingual-publishing-map.png",
  "axin-personal-ip-illustrations/assets/examples/04-axin-geo-asset-pipeline.png",
  "axin-personal-ip-illustrations/assets/examples/05-axin-repo-review-desk.png",
  "docs/MULTI_PLATFORM.md",
  "docs/GEO.md",
  "docs/REPOSITORY_REVIEW.md",
  "docs/index.html",
  ".claude-plugin/plugin.json",
  ".claude-plugin/marketplace.json",
  ".claude-plugin/commands/axin-illustrate.md",
  ".claude-plugin/skills/axin-personal-ip-illustrations/SKILL.md",
  ".cursor/rules/axin-personal-ip-illustrations.mdc",
  ".windsurfrules",
  ".clinerules/axin-personal-ip-illustrations.md",
  "platforms/codex/README.md",
  "platforms/hermes/README.md",
  "platforms/claude-code/README.md",
  "platforms/generic-agents/README.md",
  "skill-package.json",
  "prompts/axin-example-prompts.jsonl",
  "examples/prompts.md",
  "scripts/install-local-skill.ps1",
  "scripts/install-hermes-skill.ps1",
  "scripts/install-all-platforms.ps1",
  "scripts/sync-platform-packages.ps1",
  "scripts/generate-axin-examples-cli.ps1",
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

$forbiddenPaths = @(
  "amo-personal-ip-illustrations",
  "docs/AUTHORIZED_STARFISH_CHARACTER.md",
  "prompts/authorized-starfish-hero.md",
  "scripts/generate-authorized-starfish-cli.ps1",
  "scripts/generate-starfish-example.py",
  "axin-personal-ip-illustrations/references/pai-star-ip.md",
  "axin-personal-ip-illustrations/references/amo-ip.md"
)

foreach ($path in $forbiddenPaths) {
  if (Test-Path -LiteralPath (Join-Path $repoRoot $path)) {
    throw "Forbidden legacy path still exists: $path"
  }
}

$textFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -File |
  Where-Object {
    $_.FullName -notmatch "\\.git\\" -and
    $_.FullName -notmatch "\\assets\\examples\\" -and
    $_.FullName -notmatch "\\docs\\REPOSITORY_REVIEW\.md$" -and
    $_.FullName -notmatch "\\scripts\\validate-repo\.ps1$" -and
    $_.Extension -in @(".md", ".txt", ".json", ".yaml", ".yml", ".ps1", ".html", ".mdc", ".jsonl")
  }

$oldAmoName = -join @([char]38463, [char]22696)
$oldAuthorizedStarfish = -join @([char]25480, [char]26435, [char]28023, [char]26143)
$oldPatrickDirection = -join @([char]27966, [char]22823, [char]26143)
$forbiddenText = @(
  $oldAmoName,
  "Amo",
  "authorized starfish",
  "Authorized starfish",
  $oldAuthorizedStarfish,
  $oldPatrickDirection,
  "pai-star-ip",
  "authorized-starfish",
  "03-authorized-starfish-operator",
  "01-amo-character-anchor",
  "02-personal-ip-factory"
)

foreach ($file in $textFiles) {
  $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
  foreach ($needle in $forbiddenText) {
    if ($content.Contains($needle)) {
      $relative = Resolve-Path -LiteralPath $file.FullName -Relative
      throw "Forbidden legacy text '$needle' found in $relative"
    }
  }
}

$skill = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "axin-personal-ip-illustrations/SKILL.md")
if ($skill -notmatch "name:\s*axin-personal-ip-illustrations") {
  throw "SKILL.md metadata name is missing or incorrect."
}

if ($skill -notmatch "platforms:\s*\[codex,\s*hermes") {
  throw "SKILL.md does not advertise multi-platform support."
}

if ($skill -notmatch "references/axin-ip.md") {
  throw "SKILL.md must point to references/axin-ip.md."
}

$readme = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "README.md")
if ($readme -notmatch "README\.en\.md" -or $readme -notmatch "01-axin-character-anchor\.png") {
  throw "README.md is missing bilingual link or Axin example assets."
}

$readmeEn = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "README.en.md")
if ($readmeEn -notmatch "Axin Personal IP" -or $readmeEn -notmatch "README\.md") {
  throw "README.en.md is missing core English overview or Chinese link."
}

$llms = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "llms.txt")
if ($llms -notmatch "Skill source" -or $llms -notmatch "Multi-platform" -or $llms -notmatch "Axin") {
  throw "llms.txt is missing key LLM discovery content."
}

$package = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "skill-package.json") | ConvertFrom-Json
if ($package.name -ne "axin-personal-ip-illustrations") {
  throw "skill-package.json has the wrong package name."
}
foreach ($entry in @("codex", "hermes", "claude_code", "generic_agents")) {
  if (-not $package.entrypoints.$entry) {
    throw "skill-package.json missing entrypoint: $entry"
  }
}

$pluginSkill = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot ".claude-plugin/skills/axin-personal-ip-illustrations/SKILL.md")
if ($pluginSkill -notmatch "references/axin-ip.md" -or $pluginSkill -notmatch "name:\s*axin-personal-ip-illustrations") {
  throw "Claude plugin skill snapshot is stale. Run scripts/sync-platform-packages.ps1."
}

$images = Get-ChildItem -LiteralPath (Join-Path $repoRoot "axin-personal-ip-illustrations/assets/examples") -Filter "*.png"
if ($images.Count -lt 5) {
  throw "Expected at least 5 Axin example images, found $($images.Count)."
}

Add-Type -AssemblyName System.Drawing
foreach ($image in $images) {
  if ($image.Length -lt 50000) {
    throw "Image looks too small or invalid: $($image.FullName)"
  }

  $img = [System.Drawing.Image]::FromFile($image.FullName)
  try {
    if ($image.Name -eq "01-axin-character-anchor.png") {
      if ($img.Width -lt 1024 -or $img.Height -lt 1024) {
        throw "Character anchor image is too small: $($img.Width)x$($img.Height)"
      }
      $ratio = [Math]::Round($img.Width / $img.Height, 3)
      if ([Math]::Abs($ratio - 1.0) -gt 0.02) {
        throw "Character anchor image is not square: $($img.Width)x$($img.Height)"
      }
    }
    else {
      if ($img.Width -lt 1600 -or $img.Height -lt 900) {
        throw "Example image is too small: $($image.Name) $($img.Width)x$($img.Height)"
      }
      $ratio = [Math]::Round($img.Width / $img.Height, 3)
      if ([Math]::Abs($ratio - 1.778) -gt 0.02) {
        throw "Example image is not 16:9: $($image.Name) $($img.Width)x$($img.Height)"
      }
    }
  }
  finally {
    $img.Dispose()
  }
}

Write-Host "Validation passed."
