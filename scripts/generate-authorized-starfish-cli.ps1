param(
  [switch]$Run,
  [string]$PromptFile = "prompts/authorized-starfish-hero.md",
  [string]$Out = "amo-personal-ip-illustrations/assets/examples/03-authorized-starfish-operator.png",
  [string]$Model = "gpt-image-2",
  [string]$Size = "2048x1152",
  [string]$Quality = "high"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$promptPath = Join-Path $repoRoot $PromptFile
$outPath = Join-Path $repoRoot $Out
$imageGen = Join-Path $env:USERPROFILE ".codex\skills\.system\imagegen\scripts\image_gen.py"

if (-not (Test-Path -LiteralPath $promptPath)) {
  throw "Prompt file not found: $promptPath"
}

if (-not (Test-Path -LiteralPath $imageGen)) {
  throw "image_gen.py not found: $imageGen"
}

$cmd = @(
  "python",
  "`"$imageGen`"",
  "generate",
  "--model", $Model,
  "--prompt-file", "`"$promptPath`"",
  "--size", $Size,
  "--quality", $Quality,
  "--out", "`"$outPath`"",
  "--force"
)

Write-Host ($cmd -join " ")

if (-not $Run) {
  Write-Host "Dry command only. Re-run with -Run after the user explicitly confirms CLI image generation."
  exit 0
}

if (-not $env:OPENAI_API_KEY) {
  throw "OPENAI_API_KEY is not set."
}

& python $imageGen generate `
  --model $Model `
  --prompt-file $promptPath `
  --size $Size `
  --quality $Quality `
  --out $outPath `
  --force

Write-Host "Generated $outPath"

