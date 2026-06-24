param(
  [switch]$Run,
  [string]$PromptFile = "prompts/axin-example-prompts.jsonl",
  [string]$OutDir = "axin-personal-ip-illustrations/assets/examples",
  [string]$Model = "gpt-image-2",
  [int]$Concurrency = 3
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$promptPath = Join-Path $repoRoot $PromptFile
$outPath = Join-Path $repoRoot $OutDir
$imageGen = Join-Path $env:USERPROFILE ".codex\skills\.system\imagegen\scripts\image_gen.py"

if (-not (Test-Path -LiteralPath $promptPath)) {
  throw "Prompt file not found: $promptPath"
}

if (-not (Test-Path -LiteralPath $imageGen)) {
  throw "image_gen.py not found: $imageGen"
}

New-Item -ItemType Directory -Force -Path $outPath | Out-Null

$cmd = @(
  "python",
  "`"$imageGen`"",
  "generate-batch",
  "--model", $Model,
  "--input", "`"$promptPath`"",
  "--out-dir", "`"$outPath`"",
  "--concurrency", $Concurrency,
  "--force"
)

Write-Host ($cmd -join " ")

if (-not $Run) {
  Write-Host "Dry command only. Re-run with -Run to call the image generation API."
  exit 0
}

if (-not $env:OPENAI_API_KEY) {
  throw "OPENAI_API_KEY is not set."
}

& python $imageGen generate-batch `
  --model $Model `
  --input $promptPath `
  --out-dir $outPath `
  --concurrency $Concurrency `
  --force

Write-Host "Generated Axin example assets in $outPath"
