param(
  [switch]$Run,
  [string]$PromptFile = "prompts/axin-example-prompts.jsonl",
  [string]$OutDir = "axin-personal-ip-illustrations/assets/examples",
  [string]$ReferenceImage = "axin-personal-ip-illustrations/assets/examples/01-axin-human-bilingual-workflow.png",
  [string]$Model = "gpt-image-2",
  [string]$Quality = "high"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$promptPath = Join-Path $repoRoot $PromptFile
$outPath = Join-Path $repoRoot $OutDir
$referencePath = Join-Path $repoRoot $ReferenceImage
$imageGen = Join-Path $env:USERPROFILE ".codex\skills\.system\imagegen\scripts\image_gen.py"

if (-not (Test-Path -LiteralPath $promptPath)) {
  throw "Prompt file not found: $promptPath"
}

if (-not (Test-Path -LiteralPath $imageGen)) {
  throw "image_gen.py not found: $imageGen"
}

if (-not (Test-Path -LiteralPath $referencePath)) {
  throw "Reference image not found: $referencePath"
}

New-Item -ItemType Directory -Force -Path $outPath | Out-Null

$jobs = Get-Content -LiteralPath $promptPath -Encoding UTF8 |
  Where-Object { $_.Trim().Length -gt 0 } |
  ForEach-Object { $_ | ConvertFrom-Json }

if ($jobs.Count -eq 0) {
  throw "No prompt jobs found in $promptPath"
}

Write-Host "Axin reference image: $referencePath"

foreach ($job in $jobs) {
  $target = Join-Path $outPath $job.out
  $cmd = @(
    "python",
    "`"$imageGen`"",
    "edit",
    "--model", $Model,
    "--image", "`"$referencePath`"",
    "--prompt", "`"<prompt from $PromptFile>`"",
    "--size", $job.size,
    "--quality", $Quality,
    "--out", "`"$target`"",
    "--force"
  )

  Write-Host ($cmd -join " ")
}

if (-not $Run) {
  Write-Host "Dry command only. Re-run with -Run to call the image editing API."
  exit 0
}

if (-not $env:OPENAI_API_KEY) {
  throw "OPENAI_API_KEY is not set."
}

foreach ($job in $jobs) {
  $target = Join-Path $outPath $job.out
  Write-Host "Generating $($job.out)"
  & python $imageGen edit `
    --model $Model `
    --image $referencePath `
    --prompt $job.prompt `
    --size $job.size `
    --quality $Quality `
    --out $target `
    --force
}

Write-Host "Generated Axin example assets in $outPath"
