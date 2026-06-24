param(
  [string]$Topic = "",

  [string]$Slug = "",

  [string]$SourcePath = "",

  [string]$ArticlePath = "",

  [string]$ArticleText = "",

  [int]$ImageCount = 4,

  [ValidateSet("auto", "zh", "en", "bilingual")]
  [string]$LanguageMode = "auto",

  [string]$CharacterName = "",

  [string]$CharacterNameEn = "Axin",

  [string]$CharacterDescription = "",

  [string]$CharacterImagePath = "",

  [string]$OutRoot = "content-packages",

  [switch]$Help
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

function Show-Help {
@'
new-content-package.ps1 - Create an article-to-illustration prompt package.

Quick start:
  .\scripts\new-content-package.ps1 -ArticlePath .\examples\sample-article.md -ImageCount 4 -LanguageMode zh

With a custom IP character reference:
  .\scripts\new-content-package.ps1 -ArticlePath .\examples\sample-article.md -CharacterImagePath .\assets\my-ip.png -CharacterName "Your IP" -ImageCount 4

Key outputs:
  content-packages\<slug>\analysis.md
  content-packages\<slug>\illustration-shot-list.md
  content-packages\<slug>\image-prompts.md
  content-packages\<slug>\image-prompts.jsonl
  content-packages\<slug>\distribution-plan.md
  content-packages\<slug>\publish-checklist.md

Important parameters:
  -ArticlePath          Markdown or TXT article to analyze.
  -ArticleText          Inline article text, useful for automation.
  -CharacterImagePath   Optional custom IP reference image.
  -CharacterName        Optional custom IP display name.
  -ImageCount           Number of image prompts, clamped to 1-8.
  -LanguageMode         auto, zh, en, or bilingual.
  -Slug                 Output folder name under content-packages.
  -OutRoot              Output root, relative to the repo or absolute.

This script generates reviewable prompts. It does not generate PNG files.
'@ | Write-Host
}

if ($Help) {
  Show-Help
  return
}

function New-UString {
  param([int[]]$CodePoints)

  return -join ($CodePoints | ForEach-Object { [char]$_ })
}

if ([string]::IsNullOrWhiteSpace($CharacterName)) {
  $CharacterName = New-UString 38463,37995
}

function Convert-ToSlug {
  param([string]$Value)

  $slug = $Value.ToLowerInvariant()
  $slug = $slug -replace "[^a-z0-9]+", "-"
  $slug = $slug.Trim("-")
  if ([string]::IsNullOrWhiteSpace($slug)) {
    return "content-package"
  }
  return $slug
}

function Resolve-RepoPath {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) {
    return ""
  }

  if ([System.IO.Path]::IsPathRooted($Value)) {
    return [System.IO.Path]::GetFullPath($Value)
  }

  return [System.IO.Path]::GetFullPath((Join-Path $repoRoot $Value))
}

function Resolve-OutRoot {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) {
    return (Join-Path $repoRoot "content-packages")
  }

  if ([System.IO.Path]::IsPathRooted($Value)) {
    return [System.IO.Path]::GetFullPath($Value)
  }

  return [System.IO.Path]::GetFullPath((Join-Path $repoRoot $Value))
}

function Write-PackageFile {
  param(
    [string]$PackageDir,
    [string]$Name,
    [string[]]$Lines
  )

  $path = Join-Path $PackageDir $Name
  $dir = Split-Path -Parent $path
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  Set-Content -LiteralPath $path -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8
}

function Split-ArticleParagraphs {
  param([string]$Text)

  if ([string]::IsNullOrWhiteSpace($Text)) {
    return @()
  }

  $normalized = $Text -replace "`r`n", "`n"
  $normalized = $normalized -replace "`r", "`n"
  return @(
    $normalized -split "(?:`n\s*){2,}" |
      ForEach-Object { $_.Trim() } |
      Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
  )
}

function Get-DetectedTitle {
  param(
    [string]$Text,
    [string]$Fallback
  )

  foreach ($line in ($Text -split "`n")) {
    $trimmed = $line.Trim()
    if ($trimmed -match "^#\s+(.+)$") {
      return $Matches[1].Trim()
    }
  }

  foreach ($line in ($Text -split "`n")) {
    $trimmed = $line.Trim()
    if ($trimmed.Length -gt 0 -and $trimmed.Length -le 80) {
      return $trimmed
    }
  }

  if (-not [string]::IsNullOrWhiteSpace($Fallback)) {
    return $Fallback
  }

  return "Untitled Article"
}

function Get-Headings {
  param([string]$Text)

  $items = foreach ($line in ($Text -split "`n")) {
    $trimmed = $line.Trim()
    if ($trimmed -match "^(#{1,4})\s+(.+)$") {
      "- $($Matches[2].Trim())"
    }
  }

  return @($items | Select-Object -First 12)
}

function Get-ShortText {
  param(
    [string]$Text,
    [int]$MaxLength = 180
  )

  $flat = ($Text -replace "\s+", " ").Trim()
  if ($flat.Length -le $MaxLength) {
    return $flat
  }
  return "$($flat.Substring(0, $MaxLength).Trim())..."
}

function Get-KeywordScore {
  param(
    [string]$Text,
    [string[]]$Words
  )

  $score = 0
  foreach ($word in $Words) {
    if ($Text.IndexOf($word, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
      $score += 2
    }
  }
  return $score
}

function Get-KeywordSets {
  $problem = @(
    "problem", "risk", "failure", "pitfall", "ugly", "wrong", "mock", "stub",
    (New-UString 38382,39064), (New-UString 39118,38505), (New-UString 22833,36133),
    (New-UString 19985), (New-UString 19981,34892)
  )
  $evidence = @(
    "evidence", "verify", "validated", "tested", "screenshot", "log", "commit", "raw", "GitHub",
    (New-UString 35777,25454), (New-UString 39564,35777), (New-UString 23454,27979),
    (New-UString 36816,34892), (New-UString 25130,22270), (New-UString 26657,39564)
  )
  $workflow = @(
    "workflow", "input", "output", "script", "pipeline", "prompt", "image", "reuse", "package",
    (New-UString 27969,31243), (New-UString 36755,20837), (New-UString 36755,20986),
    (New-UString 33050,26412), (New-UString 33258,21160), (New-UString 22797,29992),
    (New-UString 37197,22270)
  )
  $distribution = @(
    "WeChat", "Zhihu", "Jike", "Xiaohongshu", "README", "Hacker News", "Medium", "X", "GEO", "LLM",
    (New-UString 20844,20247,21495), (New-UString 30693,20046), (New-UString 21363,21051),
    (New-UString 23567,32418,20070), (New-UString 20013,25991), (New-UString 33521,25991)
  )
  $ip = @(
    "IP", "character", "style", "visual", "asset", "persona", "brand",
    (New-UString 24418,35937), (New-UString 35282,33394), (New-UString 39118,26684),
    (New-UString 36164,20135), (New-UString 35270,35273)
  )
  $judgement = @(
    "judgement", "judgment", "point", "claim", "takeaway", "conclusion",
    (New-UString 21028,26029), (New-UString 35266,28857), (New-UString 32467,35770)
  )

  return @(
    @{ Name = "problem"; Words = $problem },
    @{ Name = "evidence"; Words = $evidence },
    @{ Name = "workflow"; Words = $workflow },
    @{ Name = "distribution"; Words = $distribution },
    @{ Name = "ip"; Words = $ip },
    @{ Name = "judgement"; Words = $judgement }
  )
}

function Get-AnchorCategory {
  param([string]$Text)

  $bestName = "judgement"
  $bestScore = 0
  foreach ($set in (Get-KeywordSets)) {
    $score = Get-KeywordScore -Text $Text -Words $set.Words
    if ($score -gt $bestScore) {
      $bestScore = $score
      $bestName = $set.Name
    }
  }
  return $bestName
}

function Get-ArticleAnchors {
  param([string[]]$Paragraphs)

  $allWords = @()
  foreach ($set in (Get-KeywordSets)) {
    $allWords += $set.Words
  }

  $scored = foreach ($paragraph in $Paragraphs) {
    $flat = Get-ShortText -Text $paragraph -MaxLength 240
    $keywordScore = Get-KeywordScore -Text $paragraph -Words $allWords
    $lengthScore = if ($flat.Length -ge 30 -and $flat.Length -le 240) { 2 } else { 0 }
    [pscustomobject]@{
      Snippet = $flat
      Category = Get-AnchorCategory -Text $paragraph
      Score = $keywordScore + $lengthScore
    }
  }

  $anchors = @($scored | Sort-Object Score -Descending | Select-Object -First 8)
  if ($anchors.Count -eq 0) {
    $anchors = @([pscustomobject]@{
      Snippet = "No article attached yet. Paste the article into article.md or rerun with -ArticlePath / -ArticleText."
      Category = "manual"
      Score = 0
    })
  }
  return $anchors
}

function Get-EffectiveLanguageMode {
  param(
    [string]$Mode,
    [string]$Text
  )

  if ($Mode -ne "auto") {
    return $Mode
  }

  $zhCount = ([regex]::Matches($Text, "[\u4e00-\u9fff]")).Count
  $enCount = ([regex]::Matches($Text, "[A-Za-z]{2,}")).Count
  if ($zhCount -ge $enCount) {
    return "zh"
  }
  return "en"
}

function Get-SceneTemplates {
  return @(
    [pscustomobject]@{
      Key = "core-judgement"
      Title = "Core Judgement"
      Structure = "content workbench"
      IdeaPrefix = "Pull the article's sharpest claim out of the draft so the reader remembers the point first."
      Action = "The IP character stands at a clean white workbench, cutting one source draft into one clear judgement card."
      Objects = @("source draft", "judgement card", "discarded filler slips", "orange connection line")
      LabelConcepts = @("source", "judgement", "keep", "cut")
    },
    [pscustomobject]@{
      Key = "evidence-check"
      Title = "Evidence Check"
      Structure = "evidence inspection"
      IdeaPrefix = "Separate what was actually tested from estimates and missing proof."
      Action = "The IP character checks evidence cards with a magnifier and puts a small red warning tag on unverified claims."
      Objects = @("evidence cards", "magnifier", "red warning tag", "blue verification receipt")
      LabelConcepts = @("tested", "estimate", "gap", "verify")
    },
    [pscustomobject]@{
      Key = "ip-character-anchor"
      Title = "IP Character Anchor"
      Structure = "character action state"
      IdeaPrefix = "Make the custom IP character perform the content action instead of decorating the edge of the image."
      Action = "The IP character pins the reference image to a board, then connects article anchors to action sketches."
      Objects = @("character reference", "action sketches", "style notes", "article anchor cards")
      LabelConcepts = @("character", "action", "style", "point")
    },
    [pscustomobject]@{
      Key = "distribution-split"
      Title = "Bilingual Distribution Split"
      Structure = "publishing path"
      IdeaPrefix = "The same project experience is not literal translation; Chinese and English contexts consume it differently."
      Action = "The IP character routes one stack of experience cards into a Chinese-content tray and an English-repository tray."
      Objects = @("experience cards", "Chinese tray", "English tray", "orange routing lines")
      LabelConcepts = @("experience", "Chinese", "English", "adapt")
    },
    [pscustomobject]@{
      Key = "asset-loop"
      Title = "Content Asset Loop"
      Structure = "reuse flywheel"
      IdeaPrefix = "Turn one article into prompts, images, README snippets, cases, and future content material."
      Action = "The IP character feeds an article draft into a small asset machine that outputs reusable cards."
      Objects = @("article draft", "asset machine", "prompt card", "case card", "README card")
      LabelConcepts = @("article", "prompt", "image", "case", "README")
    },
    [pscustomobject]@{
      Key = "common-pitfall"
      Title = "Common Pitfall"
      Structure = "small comic sequence"
      IdeaPrefix = "Show the common mistakes: illustrating every paragraph, decorative character use, too much text, and no evidence."
      Action = "The IP character stamps out four bad mini-cards and leaves one clean image card with plenty of empty space."
      Objects = @("bad cards", "red cross marks", "clean image card", "blank white space")
      LabelConcepts = @("too busy", "decor", "no proof", "space")
    }
  )
}

function New-ImagePrompt {
  param(
    [pscustomobject]$Scene,
    [string]$CharacterLine,
    [string]$CharacterReferenceLine,
    [string]$Mode
  )

  $objects = $Scene.Objects -join " / "
  $labels = $Scene.LabelConcepts -join " / "

@"
Use case: illustration-story
Asset type: personal IP article illustration
$CharacterReferenceLine
Primary request: Generate one standalone 16:9 horizontal article illustration based on this article anchor: "$($Scene.Anchor)".

Visual DNA:
Pure white background. Minimalist black hand-drawn line art. Slightly wobbly pen lines. Lots of empty white space. Sparse red/orange/blue handwritten annotations. Clean content-workbench sketch feeling. No gradients, no shadows, no paper texture, no complex background, no commercial vector style, no PPT infographic look, no cute mascot poster, no realistic UI.

Recurring IP character required:
$CharacterLine The character must perform the core conceptual action, not decorate the scene. Preserve the identity from the reference image if one is provided.

Theme:
$($Scene.Title)

Structure type:
$($Scene.Structure)

Core idea:
$($Scene.CoreIdea)

Composition:
$($Scene.Action) Keep the scene physical and metaphorical, not a software screenshot.

Suggested elements:
$objects

Handwritten label concepts:
$labels

Language mode:
$Mode labels. If the target is zh, turn the label concepts into very short Chinese handwritten labels. If the target is en, keep concise English labels. If bilingual, use only 2-4 sparse bilingual labels.

Color use:
Black for main line art, hair, objects, and labels. Orange for main flow/path/cables/arrows. Red only for key warnings, unverified items, problems, or results. Blue only for secondary notes, AI assistance, or system state.

Constraints:
One image explains only one core structure. Keep the main subject around 40%-60% of the canvas. Preserve at least 35% blank white space. Use at most 5-8 short handwritten labels. Do not write a title in the top-left corner. Do not write the structure type on the image. Do not turn the IP character into a mascot, robot, stamp, toolbox, animal, monster, anime character, or abstract icon. Do not make it a formal diagram, course slide, dense explainer, or UI screenshot. No watermark, no logo, no extra characters.
"@
}

if ($ImageCount -lt 1) {
  $ImageCount = 1
}
if ($ImageCount -gt 8) {
  $ImageCount = 8
}

if ([string]::IsNullOrWhiteSpace($ArticlePath) -and -not [string]::IsNullOrWhiteSpace($SourcePath)) {
  $ArticlePath = $SourcePath
}

$resolvedArticlePath = Resolve-RepoPath -Value $ArticlePath
if (-not [string]::IsNullOrWhiteSpace($resolvedArticlePath)) {
  if (-not (Test-Path -LiteralPath $resolvedArticlePath)) {
    throw "Article file not found: $resolvedArticlePath"
  }
  $ArticleText = Get-Content -Raw -Encoding UTF8 -LiteralPath $resolvedArticlePath
}

$detectedTitle = Get-DetectedTitle -Text $ArticleText -Fallback $Topic
if ([string]::IsNullOrWhiteSpace($Topic)) {
  $Topic = $detectedTitle
}
if ([string]::IsNullOrWhiteSpace($Slug)) {
  $Slug = Convert-ToSlug -Value $Topic
}

$outRootPath = Resolve-OutRoot -Value $OutRoot
$packageDir = Join-Path $outRootPath $Slug
New-Item -ItemType Directory -Force -Path $packageDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $packageDir "images") | Out-Null

$sourceDisplay = if ([string]::IsNullOrWhiteSpace($resolvedArticlePath)) { "inline / not attached" } else { $resolvedArticlePath }
$paragraphs = Split-ArticleParagraphs -Text $ArticleText
$anchors = Get-ArticleAnchors -Paragraphs $paragraphs
$headings = Get-Headings -Text $ArticleText
$effectiveLanguageMode = Get-EffectiveLanguageMode -Mode $LanguageMode -Text $ArticleText

if ([string]::IsNullOrWhiteSpace($CharacterDescription)) {
  $CharacterDescription = "$CharacterName / $CharacterNameEn, a hand-drawn human content operator with black hair, round glasses, a light hoodie, quiet focused expression, and practical posture."
}

$characterReferenceLine = "Input image role: Use the default Axin character anchor from axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png as the visual reference."
$packagedCharacterPath = ""
if (-not [string]::IsNullOrWhiteSpace($CharacterImagePath)) {
  $resolvedCharacterImage = Resolve-RepoPath -Value $CharacterImagePath
  if (-not (Test-Path -LiteralPath $resolvedCharacterImage)) {
    throw "Character image file not found: $resolvedCharacterImage"
  }
  $characterDir = Join-Path $packageDir "character-reference"
  New-Item -ItemType Directory -Force -Path $characterDir | Out-Null
  $characterFileName = Split-Path -Leaf $resolvedCharacterImage
  $characterTarget = Join-Path $characterDir $characterFileName
  Copy-Item -LiteralPath $resolvedCharacterImage -Destination $characterTarget -Force
  $packagedCharacterPath = "character-reference/$characterFileName"
  $characterReferenceLine = "Input image role: Use the provided character reference image at $packagedCharacterPath. Preserve the same IP identity, hairstyle, face shape, clothing, attitude, and line-art style."
}

$characterReferenceDisplay = "default Axin anchor"
$characterReferenceAsset = "axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png"
if (-not [string]::IsNullOrWhiteSpace($packagedCharacterPath)) {
  $characterReferenceDisplay = $packagedCharacterPath
  $characterReferenceAsset = $packagedCharacterPath
}

$templates = Get-SceneTemplates
$scenes = for ($i = 0; $i -lt $ImageCount; $i++) {
  $template = $templates[$i % $templates.Count]
  $anchor = $anchors[$i % $anchors.Count]
  [pscustomobject]@{
    Index = $i + 1
    Key = $template.Key
    FileName = ("{0:D2}-{1}.png" -f ($i + 1), $template.Key)
    Title = $template.Title
    Structure = $template.Structure
    Anchor = $anchor.Snippet
    AnchorCategory = $anchor.Category
    CoreIdea = "$($template.IdeaPrefix) Article anchor: $($anchor.Snippet)"
    Action = $template.Action
    Objects = $template.Objects
    LabelConcepts = $template.LabelConcepts
  }
}

$prompts = foreach ($scene in $scenes) {
  $prompt = New-ImagePrompt -Scene $scene -CharacterLine $CharacterDescription -CharacterReferenceLine $characterReferenceLine -Mode $effectiveLanguageMode
  [pscustomobject]@{
    Scene = $scene
    Prompt = $prompt
  }
}

$charCount = if ([string]::IsNullOrWhiteSpace($ArticleText)) { 0 } else { $ArticleText.Length }
$zhCount = ([regex]::Matches($ArticleText, "[\u4e00-\u9fff]")).Count
$enWordCount = ([regex]::Matches($ArticleText, "[A-Za-z]{2,}")).Count
$articleBodyForPackage = "Paste the article here, then rerun this script with -ArticlePath or -ArticleText."
if (-not [string]::IsNullOrWhiteSpace($ArticleText)) {
  $articleBodyForPackage = $ArticleText.Trim()
}

Write-PackageFile $packageDir "article.md" @(
  "# Source Article",
  "",
  "- Topic: $Topic",
  "- Source path: $sourceDisplay",
  "- Character reference: $characterReferenceDisplay",
  "",
  '```text',
  $articleBodyForPackage,
  '```'
)

$analysisLines = @(
  "# Article Analysis",
  "",
  "- Topic: $Topic",
  "- Detected title: $detectedTitle",
  "- Source path: $sourceDisplay",
  "- Paragraphs: $($paragraphs.Count)",
  "- Characters: $charCount",
  "- Chinese characters: $zhCount",
  "- English word-like tokens: $enWordCount",
  "- Label language mode: $effectiveLanguageMode",
  "- Target image prompts: $ImageCount",
  "",
  "## Headings",
  ""
)
if ($headings.Count -gt 0) {
  $analysisLines += $headings
} else {
  $analysisLines += "- No markdown headings detected."
}
$analysisLines += @("", "## Cognitive Anchors", "")
$analysisLines += ($anchors | ForEach-Object { "- [$($_.Category)] $($_.Snippet)" })
$analysisLines += @(
  "",
  "## Analysis Rule",
  "",
  "Do not illustrate every paragraph. Pick the judgement, evidence, workflow, IP action, distribution split, or reusable asset loop that the reader should remember."
)
Write-PackageFile $packageDir "analysis.md" $analysisLines

Write-PackageFile $packageDir "brief.md" @(
  "# Content Package Brief",
  "",
  "- Topic: $Topic",
  "- Slug: $Slug",
  "- Source path: $sourceDisplay",
  "- Character name: $CharacterName / $CharacterNameEn",
  "- Character reference: $characterReferenceDisplay",
  "- Core promise: turn one article into reusable IP illustration prompts and bilingual distribution assets.",
  "- Target audience: readers who need reusable personal IP content, not decorative images.",
  "- Current status: generated from local article analysis; review before publishing.",
  "- Main evidence: see analysis.md and evidence.md.",
  "- Main risk: prompts are only as good as the article anchors and character reference.",
  "- Reusable assets: image-prompts.md, image-prompts.jsonl, distribution-plan.md, readme-snippet.md.",
  "",
  "## One-sentence judgement",
  "",
  "A personal IP illustration workflow should start from the article's real judgement, then produce image prompts that preserve the IP character and fit Chinese and English publishing contexts."
)

$evidenceLines = @(
  "# Evidence",
  "",
  "Separate observed facts from estimates.",
  "",
  "## Observed In Article",
  ""
)
$evidenceLines += ($anchors | Select-Object -First 5 | ForEach-Object { "- $($_.Snippet)" })
$evidenceLines += @(
  "",
  "## Needs Manual Verification",
  "",
  "- Whether the article claims are backed by real commands, screenshots, commits, or user-visible outputs.",
  "- Whether the IP reference image is authorized and stable enough for repeated use.",
  "- Whether the generated prompts keep the character doing the core action.",
  "",
  "## Verification Commands",
  "",
  "    .\scripts\validate-repo.ps1"
)
Write-PackageFile $packageDir "evidence.md" $evidenceLines

Write-PackageFile $packageDir "zh-draft.md" @(
  "# Chinese Distribution Draft",
  "",
  "## WeChat",
  "",
  "- Angle: full process, real judgement, evidence, correction, and reusable method.",
  "- Best images: Core Judgement, Evidence Check, Content Asset Loop.",
  "",
  "## Zhihu",
  "",
  "- Angle: answer a concrete question with clear tradeoffs.",
  "- Best images: Common Pitfall, Evidence Check, Bilingual Distribution Split.",
  "",
  "## Jike",
  "",
  "- Angle: public-build log, what changed today, what can be reused.",
  "- Best images: Content Workbench, Distribution Split, Asset Loop.",
  "",
  "## Xiaohongshu",
  "",
  "- Angle: IP asset board, concise steps, before/after contrast, no poster-like hard selling.",
  "- Best images: IP Character Anchor and 1-2 clean article illustrations."
)

Write-PackageFile $packageDir "en-brief.md" @(
  "# English Distribution Brief",
  "",
  "## GitHub / README",
  "",
  "- Angle: explain the workflow, files, generated prompts, and repeatable usage.",
  "- Visuals: use core judgement, asset loop, and character anchor images.",
  "",
  "## Hacker News",
  "",
  "- Angle: focus on the practical workflow: article input -> content anchors -> image prompts -> distribution assets.",
  "- Visuals: avoid promotional language; show one clear workflow image.",
  "",
  "## X",
  "",
  "- Angle: short build note with one before/after or asset-loop visual.",
  "- Visuals: use one strong image with very sparse English labels.",
  "",
  "## Medium",
  "",
  "- Angle: longer essay on turning project work into reusable personal IP assets.",
  "- Visuals: use 3-4 images across judgement, evidence, distribution, and reuse."
)

$shotLines = @("# Illustration Shot List", "")
foreach ($scene in $scenes) {
  $shotLines += "## $($scene.Index). $($scene.Title)"
  $shotLines += ""
  $shotLines += "- Output file: images/$($scene.FileName)"
  $shotLines += "- Article anchor: $($scene.Anchor)"
  $shotLines += "- Anchor category: $($scene.AnchorCategory)"
  $shotLines += "- Core idea: $($scene.CoreIdea)"
  $shotLines += "- Structure type: $($scene.Structure)"
  $shotLines += "- Character action: $($scene.Action)"
  $shotLines += "- Suggested elements: $($scene.Objects -join ' / ')"
  $shotLines += "- Label concepts: $($scene.LabelConcepts -join ' / ')"
  $shotLines += ""
}
Write-PackageFile $packageDir "illustration-shot-list.md" $shotLines

$promptLines = @("# Image Prompts", "")
foreach ($item in $prompts) {
  $scene = $item.Scene
  $promptLines += "## $($scene.Index). $($scene.Title)"
  $promptLines += ""
  $promptLines += "- Output file: images/$($scene.FileName)"
  $promptLines += "- Character reference: $characterReferenceDisplay"
  $promptLines += ""
  $promptLines += '```text'
  $promptLines += $item.Prompt.Trim()
  $promptLines += '```'
  $promptLines += ""
}
Write-PackageFile $packageDir "image-prompts.md" $promptLines

$jsonLines = foreach ($item in $prompts) {
  [pscustomobject]@{
    out = "images/$($item.Scene.FileName)"
    size = "2048x1152"
    quality = "high"
    use_case = "illustration-story"
    character_reference = $characterReferenceAsset
    prompt = $item.Prompt.Trim()
  } | ConvertTo-Json -Depth 5 -Compress
}
Write-PackageFile $packageDir "image-prompts.jsonl" $jsonLines

Write-PackageFile $packageDir "distribution-plan.md" @(
  "# Bilingual Distribution Plan",
  "",
  "The value is not translation. The value is letting the same project experience become two publishing experiences.",
  "",
  "## Chinese Context",
  "",
  "- WeChat: deep process, real judgement, evidence, and reusable method.",
  "- Zhihu: answer a concrete question with clear tradeoffs.",
  "- Jike: public-build log and current progress.",
  "- Xiaohongshu: visual asset board, concise steps, and before/after contrast.",
  "",
  "## English Context",
  "",
  "- GitHub / README: repeatable workflow, files, prompts, and proof.",
  "- Hacker News: practical build story; avoid marketing tone.",
  "- X: short build note with one strong image.",
  "- Medium: longer essay on the content system and reusable IP assets.",
  "",
  "## Reuse Rule",
  "",
  "Chinese copy can explain the messy process. English copy should explain the artifact, workflow, and why another builder can reuse it."
)

Write-PackageFile $packageDir "readme-snippet.md" @(
  "# README Snippet",
  "",
  '```md',
  "## Article-To-Illustration Package",
  "",
  "This package turns one article into:",
  "",
  "- article analysis and cognitive anchors",
  "- a focused illustration shot list",
  "- ready-to-use image prompts",
  "- bilingual distribution notes",
  "- publish checklist",
  "",
  "Generate a package:",
  "",
  '```powershell',
  ".\scripts\new-content-package.ps1 -ArticlePath .\path\to\article.md -CharacterImagePath .\path\to\ip.png -CharacterName `"Your IP`" -ImageCount 4",
  '```',
  '```'
)

Write-PackageFile $packageDir "publish-checklist.md" @(
  "# Publish Checklist",
  "",
  "## Before Image Generation",
  "",
  "- [ ] Article source is attached in article.md.",
  "- [ ] Character reference image is attached or default Axin is acceptable.",
  "- [ ] image-prompts.md contains one prompt per image.",
  "- [ ] Each prompt makes the IP character perform the core action.",
  "- [ ] Labels match the target publishing language.",
  "- [ ] The shot list does not illustrate every paragraph blindly.",
  "",
  "## Before Publishing",
  "",
  "- [ ] Done / partial / stub are separated.",
  "- [ ] Claims have evidence.",
  "- [ ] Chinese and English distribution angles are different, not literal translations.",
  "- [ ] README and English entry are aligned if this becomes a repo case.",
  "- [ ] llms.txt or docs are updated if needed.",
  "- [ ] Images are saved under the project asset folder.",
  "- [ ] Validation commands have been run.",
  "",
  "## Commands",
  "",
  "    .\scripts\validate-repo.ps1"
)

$metadata = [pscustomobject]@{
  topic = $Topic
  slug = $Slug
  source_path = $sourceDisplay
  character_name = $CharacterName
  character_name_en = $CharacterNameEn
  character_reference = $characterReferenceDisplay
  image_count = $ImageCount
  language_mode = $effectiveLanguageMode
  generated_files = @(
    "article.md",
    "analysis.md",
    "brief.md",
    "evidence.md",
    "zh-draft.md",
    "en-brief.md",
    "illustration-shot-list.md",
    "image-prompts.md",
    "image-prompts.jsonl",
    "distribution-plan.md",
    "readme-snippet.md",
    "publish-checklist.md"
  )
}
Set-Content -LiteralPath (Join-Path $packageDir "metadata.json") -Value ($metadata | ConvertTo-Json -Depth 5) -Encoding UTF8

Write-Host "Created content package at $packageDir"
Write-Host "Review image prompts at $(Join-Path $packageDir 'image-prompts.md')"
