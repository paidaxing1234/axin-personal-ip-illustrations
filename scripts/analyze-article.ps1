param(
  [string]$ArticlePath = "",

  [string]$ArticleText = "",

  [string]$Topic = "",

  [int]$ImageCount = 4,

  [string]$OutFile = "",

  [switch]$Json,

  [switch]$Help
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot "lib\ContentDiagnosis.ps1")

function Show-Help {
@'
analyze-article.ps1 - Diagnose whether an article is ready to become IP illustration assets.

Quick start:
  .\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md

Write a markdown report:
  .\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md -OutFile .\reports\content-diagnosis.md

Return JSON for automation:
  .\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md -Json

This script does not generate image prompts. It checks judgement, evidence, workflow, audience, risk, and visual readiness first.
'@ | Write-Host
}

if ($Help) {
  Show-Help
  return
}

$sourceDisplay = "inline / not attached"
if (-not [string]::IsNullOrWhiteSpace($ArticlePath)) {
  $resolvedArticlePath = Get-AxinResolvedPath -Value $ArticlePath -BasePath $repoRoot
  if (-not (Test-Path -LiteralPath $resolvedArticlePath)) {
    throw "Article file not found: $resolvedArticlePath"
  }
  $ArticleText = Get-Content -Raw -Encoding UTF8 -LiteralPath $resolvedArticlePath
  $sourceDisplay = $resolvedArticlePath
}

if ([string]::IsNullOrWhiteSpace($ArticleText)) {
  throw "No article content provided. Use -ArticlePath or -ArticleText."
}

if ([string]::IsNullOrWhiteSpace($Topic)) {
  foreach ($line in ($ArticleText -split "`n")) {
    $trimmed = $line.Trim()
    if ($trimmed -match "^#\s+(.+)$") {
      $Topic = $Matches[1].Trim()
      break
    }
  }
}

if ([string]::IsNullOrWhiteSpace($Topic)) {
  $Topic = "Untitled Article"
}

$diagnosis = Get-AxinArticleDiagnosis -ArticleText $ArticleText -Topic $Topic -SourcePath $sourceDisplay -ImageCount $ImageCount

if ($Json) {
  $diagnosis | ConvertTo-Json -Depth 6
  return
}

$lines = Format-AxinDiagnosisMarkdown -Diagnosis $diagnosis
if (-not [string]::IsNullOrWhiteSpace($OutFile)) {
  $outPath = Get-AxinResolvedPath -Value $OutFile -BasePath $repoRoot
  $outDir = Split-Path -Parent $outPath
  if (-not [string]::IsNullOrWhiteSpace($outDir)) {
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  }
  Set-Content -LiteralPath $outPath -Value ($lines -join [Environment]::NewLine) -Encoding UTF8
  Write-Host "Wrote content diagnosis to $outPath"
  return
}

$lines -join [Environment]::NewLine
