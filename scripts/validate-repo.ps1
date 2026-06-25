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
  "axin-personal-ip-illustrations/assets/examples/01-axin-human-bilingual-workflow.png",
  "axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png",
  "axin-personal-ip-illustrations/assets/examples/03-axin-human-repo-review-desk.png",
  "axin-personal-ip-illustrations/assets/examples/04-axin-human-geo-agent-discovery.png",
  "axin-personal-ip-illustrations/assets/examples/05-axin-human-content-reuse-workbench.png",
  "axin-personal-ip-illustrations/assets/examples/06-axin-ip-asset-board.png",
  "assets/character-library/README.md",
  "cases/README.md",
  "cases/first-public-build/README.md",
  "docs/AXIN_CONTENT_OS.md",
  "docs/CHARACTER_LIBRARY.md",
  "docs/MULTI_PLATFORM.md",
  "docs/GEO.md",
  "docs/QUICK_START.md",
  "docs/QUICK_START.en.md",
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
  "examples/sample-article.md",
  "content-packages/.gitkeep",
  "scripts/install-local-skill.ps1",
  "scripts/install-hermes-skill.ps1",
  "scripts/install-all-platforms.ps1",
  "scripts/sync-platform-packages.ps1",
  "scripts/generate-axin-examples-cli.ps1",
  "scripts/lib/ContentDiagnosis.ps1",
  "scripts/lib/SemanticReview.ps1",
  "scripts/analyze-article.ps1",
  "scripts/new-content-package.ps1",
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

function Join-AxinHiddenParts {
  param([Parameter(Mandatory)][string[]]$Parts)
  return ($Parts -join "")
}

function Join-AxinCodePoints {
  param([Parameter(Mandatory)][int[]]$Codes)
  return -join ($Codes | ForEach-Object { [char]$_ })
}

$forbiddenPaths = @(
  (Join-AxinHiddenParts @("a", "mo-personal-ip-illustrations")),
  (Join-AxinHiddenParts @("docs/", "AUTHORIZED_", "STAR", "FISH", "_CHARACTER.md")),
  (Join-AxinHiddenParts @("prompts/", "authorized-", "star", "fish", "-hero.md")),
  (Join-AxinHiddenParts @("scripts/", "generate-authorized-", "star", "fish", "-cli.ps1")),
  (Join-AxinHiddenParts @("scripts/", "generate-", "star", "fish", "-example.py")),
  (Join-AxinHiddenParts @("axin-personal-ip-illustrations/references/", "pai-", "star-ip.md")),
  (Join-AxinHiddenParts @("axin-personal-ip-illustrations/references/", "a", "mo-ip.md"))
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
    $_.Extension -in @(".md", ".txt", ".json", ".yaml", ".yml", ".ps1", ".html", ".mdc", ".jsonl")
  }

$forbiddenText = @(
  (Join-AxinCodePoints @(38463, 22696)),
  (Join-AxinHiddenParts @("A", "mo")),
  (Join-AxinHiddenParts @("authorized ", "star", "fish")),
  (Join-AxinHiddenParts @("Authorized ", "star", "fish")),
  (Join-AxinCodePoints @(25480, 26435, 28023, 26143)),
  (Join-AxinCodePoints @(27966, 22823, 26143)),
  (Join-AxinHiddenParts @("pai-", "star-ip")),
  (Join-AxinHiddenParts @("authorized-", "star", "fish")),
  (Join-AxinHiddenParts @("03-authorized-", "star", "fish", "-operator")),
  (Join-AxinHiddenParts @("01-a", "mo-character-anchor")),
  (Join-AxinHiddenParts @("02-personal", "-ip-factory")),
  (Join-AxinHiddenParts @("01-axin", "-character-anchor")),
  (Join-AxinHiddenParts @("02-axin", "-content-workbench")),
  (Join-AxinHiddenParts @("03-axin", "-bilingual-publishing-map")),
  (Join-AxinHiddenParts @("04-axin", "-geo-asset-pipeline")),
  (Join-AxinHiddenParts @("05-axin", "-repo-review-desk")),
  (Join-AxinHiddenParts @("Preserve the non", "-human character identity")),
  (Join-AxinHiddenParts @("same non", "-human Axin")),
  (Join-AxinHiddenParts @("black ink", "-stamp/toolbox body")),
  (Join-AxinHiddenParts @("small matte black ink", "-stamp and toolbox hy", "brid")),
  (Join-AxinHiddenParts @("matte black ink", "-stamp and toolbox hy", "brid workflow operator")),
  (Join-AxinHiddenParts @("No human", " body")),
  (Join-AxinHiddenParts @("no hood", "ie")),
  (Join-AxinHiddenParts @("no ha", "ir")),
  (Join-AxinHiddenParts @("screw", "-dot eyes")),
  (Join-AxinCodePoints @(24037, 20855, 31665, 30340, 28151, 21512, 20307)),
  (Join-AxinCodePoints @(40657, 33394, 21360, 31456)),
  (Join-AxinCodePoints @(38750, 20154, 31867, 24037, 20855, 31665)),
  (Join-AxinCodePoints @(27861, 20856)),
  (Join-AxinCodePoints @(29233, 39532, 20181)),
  (Join-AxinCodePoints @(20811, 21171, 24503)),
  (Join-AxinCodePoints @(20809, 26631)),
  (Join-AxinCodePoints @(24070, 26495, 36816, 21160)),
  (Join-AxinCodePoints @(20811, 33713, 24681))
)

$oldAuditDoc = Join-AxinHiddenParts @("FIVE", "_PASS", "_AUDIT")
$oldReviewDoc = Join-AxinHiddenParts @("REPOSITORY", "_REVIEW")
$oldZhAudit = Join-AxinCodePoints @(20116, 36718, 23457, 26597)
$oldZhDeepReview = Join-AxinCodePoints @(28145, 24230, 33258, 23457)
$oldEnAudit = Join-AxinHiddenParts @("Five", "-Pass Audit")
$oldEnAuditLower = Join-AxinHiddenParts @("Five", "-pass audit")
$oldEnDeepReview = Join-AxinHiddenParts @("deep self", "-review")
$oldEnRepoReview = Join-AxinHiddenParts @("Repository", " review")

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

$conversationFirst = -join @([char]23545, [char]35805, [char]20248, [char]20808)
$imageToolAvailable = "imagegen"
$noImageTool = -join @([char]27809, [char]26377, [char]22270, [char]29255, [char]29983, [char]25104, [char]24037, [char]20855)
$copyablePromptZh = -join @([char]36880, [char]24352, [char]32, [char]112, [char]114, [char]111, [char]109, [char]112, [char]116)
$cliNotPrimary = -join @([char]19981, [char]35201, [char]25226, [char]32, [char]67, [char]76, [char]73, [char]32, [char]24403, [char]25104, [char]20027, [char]20837, [char]21475)

foreach ($needle in @($conversationFirst, $imageToolAvailable, $noImageTool, $copyablePromptZh, $cliNotPrimary)) {
  if ($skill -notmatch [Regex]::Escape($needle)) {
    throw "SKILL.md must describe the conversation-first image-or-prompt workflow: $needle"
  }
}

$readme = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "README.md")
if ($readme -notmatch "README\.en\.md" -or $readme -notmatch "docs/QUICK_START\.md" -or $readme -notmatch "docs/QUICK_START\.en\.md" -or -not $readme.Contains('Use $axin-personal-ip-illustrations') -or $readme -notmatch [Regex]::Escape("image-prompts.md") -or $readme -notmatch "examples\\sample-article\.md" -or $readme -notmatch "analyze-article\.ps1" -or $readme -notmatch "Semantic" -or $readme -notmatch "OPENAI_API_KEY" -or $readme -notmatch "content-diagnosis\.md" -or $readme -notmatch "01-axin-human-bilingual-workflow\.png" -or $readme -notmatch "02-axin-human-character-anchor\.png" -or $readme -notmatch "06-axin-ip-asset-board\.png") {
  throw "README.md is missing first-run guide, bilingual link, sample article path, prompt output, or Axin example assets."
}
if ($readme.Contains($oldAuditDoc) -or $readme.Contains($oldReviewDoc) -or $readme.Contains($oldZhAudit) -or $readme.Contains($oldZhDeepReview)) {
  throw "README.md exposes internal audit/review content."
}
if ($readme -match "\|\s*`Codex`\s*\|" -or $readme -match "\|\s*`Hermes`\s*\|" -or $readme -match "\|\s*`Claude Code`\s*\|") {
  throw "README.md must not expose a front-page platform matrix; keep platform names in docs/MULTI_PLATFORM.md with notranslate markup."
}

$readmeEn = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "README.en.md")
if ($readmeEn -notmatch "Axin Personal IP" -or $readmeEn -notmatch "README\.md" -or $readmeEn -notmatch "docs/QUICK_START\.en\.md" -or -not $readmeEn.Contains('Use $axin-personal-ip-illustrations') -or $readmeEn -notmatch "image generation is available" -or $readmeEn -notmatch "no image tool is available" -or $readmeEn -notmatch "examples\\sample-article\.md" -or $readmeEn -notmatch "analyze-article\.ps1" -or $readmeEn -notmatch "Semantic" -or $readmeEn -notmatch "OPENAI_API_KEY" -or $readmeEn -notmatch "content-diagnosis\.md" -or $readmeEn -notmatch "image-prompts\.md") {
  throw "README.en.md is missing core English overview, Chinese link, first-run guide, sample article path, or prompt output."
}
if ($readmeEn.Contains($oldAuditDoc) -or $readmeEn.Contains($oldReviewDoc) -or $readmeEn.Contains($oldEnAudit) -or $readmeEn.Contains($oldEnDeepReview)) {
  throw "README.en.md exposes internal audit/review content."
}
if ($readmeEn -match "\|\s*`Codex`\s*\|" -or $readmeEn -match "\|\s*`Hermes`\s*\|" -or $readmeEn -match "\|\s*`Claude Code`\s*\|") {
  throw "README.en.md must not expose a front-page platform matrix; keep platform names in docs/MULTI_PLATFORM.md with notranslate markup."
}

$llms = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "llms.txt")
if ($llms -notmatch "Default agent behavior" -or $llms -notmatch "image generation" -or $llms -notmatch "complete copyable prompt" -or $llms -notmatch "Quick start" -or $llms -notmatch "English quick start" -or $llms -notmatch "Sample article" -or $llms -notmatch "Article diagnosis CLI" -or $llms -notmatch "Optional semantic review" -or $llms -notmatch "Skill source" -or $llms -notmatch "Platform guide" -or $llms -notmatch "Character library" -or $llms -notmatch "Article package CLI" -or $llms -notmatch "Axin") {
  throw "llms.txt is missing key LLM discovery content."
}
if ($llms.Contains($oldAuditDoc) -or $llms.Contains($oldReviewDoc) -or $llms.Contains($oldEnAuditLower) -or $llms.Contains($oldEnRepoReview)) {
  throw "llms.txt exposes internal audit/review content."
}

$contentPackageScript = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "scripts/new-content-package.ps1")
foreach ($needle in @("Help", "ArticlePath", "CharacterImagePath", "ImageCount", "LanguageMode", "content-diagnosis.md", "image-prompts.md", "image-prompts.jsonl", "distribution-plan.md")) {
  if ($contentPackageScript -notmatch [Regex]::Escape($needle)) {
    throw "new-content-package.ps1 missing article-to-prompt pipeline feature: $needle"
  }
}

$quickStart = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "docs/QUICK_START.md")
foreach ($needle in @('Use $axin-personal-ip-illustrations', "new-content-package.ps1", "analyze-article.ps1", "examples\sample-article.md", "ArticlePath", "CharacterImagePath", "Semantic", "OPENAI_API_KEY", "content-diagnosis.md", "image-prompts.md", "image-prompts.jsonl", "distribution-plan.md", "ExecutionPolicy", "Unblock-File")) {
  if ($quickStart -notmatch [Regex]::Escape($needle)) {
    throw "docs/QUICK_START.md is missing public onboarding content: $needle"
  }
}

$quickStartEn = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "docs/QUICK_START.en.md")
foreach ($needle in @('Use $axin-personal-ip-illustrations', "image generation", "no image tool", "new-content-package.ps1", "analyze-article.ps1", "examples\sample-article.md", "ArticlePath", "CharacterImagePath", "Semantic", "OPENAI_API_KEY", "content-diagnosis.md", "image-prompts.md", "image-prompts.jsonl", "distribution-plan.md", "ExecutionPolicy", "Unblock-File")) {
  if ($quickStartEn -notmatch [Regex]::Escape($needle)) {
    throw "docs/QUICK_START.en.md is missing public onboarding content: $needle"
  }
}

$sampleArticle = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "examples/sample-article.md")
foreach ($needle in @("image-prompts.md", "analysis.md", "illustration-shot-list.md", "README", "JSONL")) {
  if ($sampleArticle -notmatch [Regex]::Escape($needle)) {
    throw "examples/sample-article.md is missing expected article-to-prompt concepts: $needle"
  }
}

$diagnosisScript = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "scripts/analyze-article.ps1")
foreach ($needle in @("ArticlePath", "ArticleText", "Json", "Semantic", "SemanticModel", "OPENAI_API_KEY", "Invoke-AxinSemanticReview", "Get-AxinArticleDiagnosis", "Format-AxinDiagnosisMarkdown")) {
  if ($diagnosisScript -notmatch [Regex]::Escape($needle)) {
    throw "scripts/analyze-article.ps1 is missing diagnosis feature: $needle"
  }
}

$diagnosisLib = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "scripts/lib/ContentDiagnosis.ps1")
foreach ($needle in @("Get-AxinArticleDiagnosis", "Format-AxinDiagnosisMarkdown", "RecommendedImageCount", "ready", "usable_with_edits", "diagnose_before_prompts", "not_ready")) {
  if ($diagnosisLib -notmatch [Regex]::Escape($needle)) {
    throw "scripts/lib/ContentDiagnosis.ps1 is missing diagnosis concept: $needle"
  }
}

$semanticLib = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "scripts/lib/SemanticReview.ps1")
foreach ($needle in @("Invoke-AxinSemanticReview", "OPENAI_API_KEY", "/responses", "text", "json_schema", "store", "false", "Format-AxinSemanticReviewMarkdown")) {
  if ($semanticLib -notmatch [Regex]::Escape($needle)) {
    throw "scripts/lib/SemanticReview.ps1 is missing semantic review concept: $needle"
  }
}

$indexHtml = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "docs/index.html")
if ($indexHtml -notmatch 'translate="no"' -or $indexHtml -notmatch 'class="notranslate"' -or $indexHtml -notmatch '<meta name="google" content="notranslate">' -or $indexHtml -notmatch "06-axin-ip-asset-board\.png" -or $indexHtml -notmatch "examples\\sample-article\.md" -or $indexHtml -notmatch "analyze-article\.ps1" -or $indexHtml -notmatch "content-diagnosis\.md" -or $indexHtml -notmatch "image-prompts\.md") {
  throw "docs/index.html must prevent product-name auto-translation and show the sample article workflow plus Axin IP asset board."
}

$multiPlatform = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "docs/MULTI_PLATFORM.md")
if ($multiPlatform -notmatch 'class="notranslate"' -or $multiPlatform -notmatch 'translate="no"' -or $multiPlatform -notmatch '<table translate="no" class="notranslate">') {
  throw "docs/MULTI_PLATFORM.md must protect product names from browser auto-translation."
}
foreach ($platformName in @("Codex", "Hermes", "Claude Code", "Cursor", "Windsurf", "Cline", "OpenCode")) {
  $escaped = [Regex]::Escape($platformName)
  if ($multiPlatform -notmatch "<code translate=`"no`">$escaped</code>") {
    throw "docs/MULTI_PLATFORM.md must wrap platform name with translate=no: $platformName"
  }
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

foreach ($asset in @(
  "axin-personal-ip-illustrations/assets/examples/01-axin-human-bilingual-workflow.png",
  "axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png",
  "axin-personal-ip-illustrations/assets/examples/03-axin-human-repo-review-desk.png",
  "axin-personal-ip-illustrations/assets/examples/04-axin-human-geo-agent-discovery.png",
  "axin-personal-ip-illustrations/assets/examples/05-axin-human-content-reuse-workbench.png",
  "axin-personal-ip-illustrations/assets/examples/06-axin-ip-asset-board.png"
)) {
  if ($package.assets -notcontains $asset) {
    throw "skill-package.json missing asset: $asset"
  }
}

$pluginSkill = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot ".claude-plugin/skills/axin-personal-ip-illustrations/SKILL.md")
if ($pluginSkill -notmatch "references/axin-ip.md" -or $pluginSkill -notmatch "name:\s*axin-personal-ip-illustrations") {
  throw "Claude plugin skill snapshot is stale. Run scripts/sync-platform-packages.ps1."
}

$images = Get-ChildItem -LiteralPath (Join-Path $repoRoot "axin-personal-ip-illustrations/assets/examples") -Filter "*.png"
if ($images.Count -ne 6) {
  throw "Expected exactly 6 Axin example images, found $($images.Count)."
}

Add-Type -AssemblyName System.Drawing
foreach ($image in $images) {
  if ($image.Length -lt 50000) {
    throw "Image looks too small or invalid: $($image.FullName)"
  }

  $img = [System.Drawing.Image]::FromFile($image.FullName)
  try {
    if ($image.Name -eq "02-axin-human-character-anchor.png") {
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
