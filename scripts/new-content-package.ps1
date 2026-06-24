param(
  [Parameter(Mandatory = $true)]
  [string]$Topic,

  [string]$Slug = "",

  [string]$SourcePath = "",

  [string]$OutRoot = "content-packages"
)

$ErrorActionPreference = "Stop"

function Convert-ToSlug {
  param([string]$Value)

  $slug = $Value.ToLowerInvariant()
  $slug = $slug -replace "[^a-z0-9]+", "-"
  $slug = $slug.Trim("-")
  if ([string]::IsNullOrWhiteSpace($slug)) {
    return "axin-content-package"
  }
  return $slug
}

function Write-PackageFile {
  param(
    [string]$PackageDir,
    [string]$Name,
    [string[]]$Lines
  )

  $path = Join-Path $PackageDir $Name
  Set-Content -LiteralPath $path -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8
}

$repoRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Slug)) {
  $Slug = Convert-ToSlug -Value $Topic
}

$packageDir = Join-Path (Join-Path $repoRoot $OutRoot) $Slug
New-Item -ItemType Directory -Force -Path $packageDir | Out-Null

$sourceLine = if ([string]::IsNullOrWhiteSpace($SourcePath)) {
  "- Source path: not attached yet"
}
else {
  "- Source path: $SourcePath"
}

Write-PackageFile $packageDir "brief.md" @(
  "# Content Package Brief",
  "",
  "- Topic: $Topic",
  "- Slug: $Slug",
  $sourceLine,
  "- Core promise:",
  "- Target audience:",
  "- Current status: done / partial / stub",
  "- Main evidence:",
  "- Main risk:",
  "- Reusable assets:",
  "",
  "## One-sentence judgement",
  "",
  "Write the sharpest judgement this project proves.",
  "",
  "## Suggested Axin angle",
  "",
  "Axin should appear as a hand-drawn human with black hair, round glasses, and a hoodie. He should perform the real action, not decorate the page."
)

Write-PackageFile $packageDir "evidence.md" @(
  "# Evidence",
  "",
  "Separate observed facts from estimates.",
  "",
  "## Done",
  "",
  "- ",
  "",
  "## Partial",
  "",
  "- ",
  "",
  "## Stub / Missing",
  "",
  "- ",
  "",
  "## Verification Commands",
  "",
  "Add real commands here, for example:",
  "",
  "    .\scripts\validate-repo.ps1"
)

Write-PackageFile $packageDir "zh-draft.md" @(
  "# Chinese Draft",
  "",
  "## Title Candidates",
  "",
  "- ",
  "",
  "## Opening",
  "",
  "Record the real judgement behind this project, not only the packaging.",
  "",
  "## Structure",
  "",
  "1. Original problem:",
  "2. What was done:",
  "3. Where it drifted:",
  "4. How it was corrected:",
  "5. What can be reused:",
  "",
  "## Ending",
  "",
  "State how this workflow can be reused next time."
)

Write-PackageFile $packageDir "en-brief.md" @(
  "# English Brief",
  "",
  "## Repository / Project Summary",
  "",
  "Summarize what this project does in plain English.",
  "",
  "## Why It Matters",
  "",
  "- Real problem:",
  "- Reusable workflow:",
  "- Public artifact:",
  "",
  "## LLM Discovery Notes",
  "",
  "- Main entity:",
  "- Key files:",
  "- Suggested llms.txt update:"
)

Write-PackageFile $packageDir "illustration-shot-list.md" @(
  "# Illustration Shot List",
  "",
  "## 1. Core Workflow",
  "",
  "- Theme:",
  "- Core idea:",
  "- Axin action:",
  "- Objects:",
  "- Labels:",
  "",
  "## 2. Evidence Check",
  "",
  "- Theme:",
  "- Core idea:",
  "- Axin action:",
  "- Objects:",
  "- Labels:",
  "",
  "## 3. Publishing Split",
  "",
  "- Theme:",
  "- Core idea:",
  "- Axin action:",
  "- Objects:",
  "- Labels:"
)

Write-PackageFile $packageDir "publish-checklist.md" @(
  "# Publish Checklist",
  "",
  "## Before Publishing",
  "",
  "- [ ] Done / partial / stub are separated.",
  "- [ ] Claims have evidence.",
  "- [ ] README and English entry are aligned.",
  "- [ ] llms.txt or docs are updated if needed.",
  "- [ ] Illustration prompts preserve human Axin.",
  "- [ ] Images are saved under the project asset folder.",
  "- [ ] Validation commands have been run.",
  "",
  "## Commands",
  "",
  "    .\scripts\validate-repo.ps1"
)

Write-Host "Created content package at $packageDir"
