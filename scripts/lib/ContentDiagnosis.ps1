function Get-AxinResolvedPath {
  param(
    [string]$Value,
    [string]$BasePath
  )

  if ([string]::IsNullOrWhiteSpace($Value)) {
    return ""
  }

  if ([System.IO.Path]::IsPathRooted($Value)) {
    return [System.IO.Path]::GetFullPath($Value)
  }

  return [System.IO.Path]::GetFullPath((Join-Path $BasePath $Value))
}

function Get-AxinShortText {
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

function Get-AxinParagraphs {
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

function New-AxinUString {
  param([int[]]$CodePoints)

  return -join ($CodePoints | ForEach-Object { [char]$_ })
}

function Get-AxinKeywordSets {
  $judgement = @(
    "should", "must", "because", "therefore", "takeaway", "lesson", "judgement", "judgment", "claim", "conclusion", "tradeoff", "decision", "worth", "not just", "not only",
    (New-AxinUString 21028,26029), (New-AxinUString 35266,28857), (New-AxinUString 32467,35770), (New-AxinUString 20215,20540), (New-AxinUString 24517,39035),
    (New-AxinUString 19981,26159), (New-AxinUString 32780,26159), (New-AxinUString 26368,22312,24847), (New-AxinUString 24212,35813)
  )
  $evidence = @(
    "tested", "verified", "validated", "screenshot", "log", "commit", "raw", "result", "demo", "ran", "measured", "proof", "evidence", "output", "real", "done", "partial", "stub",
    (New-AxinUString 35777,25454), (New-AxinUString 39564,35777), (New-AxinUString 23454,27979), (New-AxinUString 25130,22270), (New-AxinUString 36816,34892),
    (New-AxinUString 23436,25104), (New-AxinUString 35745,21010), (New-AxinUString 21344,20301), (New-AxinUString 30495,23454)
  )
  $workflow = @(
    "input", "output", "workflow", "pipeline", "script", "step", "generate", "package", "prompt", "jsonl", "readme", "checklist", "asset", "reuse", "publish",
    (New-AxinUString 36755,20837), (New-AxinUString 36755,20986), (New-AxinUString 27969,31243), (New-AxinUString 33050,26412), (New-AxinUString 33258,21160),
    (New-AxinUString 29983,25104), (New-AxinUString 25552,31034,35789), (New-AxinUString 20869,23481,21253), (New-AxinUString 21457,24067), (New-AxinUString 22797,29992)
  )
  $audience = @(
    "reader", "user", "developer", "builder", "open-source", "github", "wechat", "zhihu", "medium", "hacker news", "x", "readme", "llm",
    (New-AxinUString 35835,32773), (New-AxinUString 29992,25143), (New-AxinUString 24320,21457,32773), (New-AxinUString 24320,28304),
    (New-AxinUString 20844,20247,21495), (New-AxinUString 30693,20046), (New-AxinUString 23567,32418,20070)
  )
  $risk = @(
    "risk", "pitfall", "problem", "failure", "wrong", "mock", "placeholder", "gap", "missing", "ugly", "unclear", "too generic", "only plan",
    (New-AxinUString 39118,38505), (New-AxinUString 38382,39064), (New-AxinUString 22833,36133), (New-AxinUString 38169), (New-AxinUString 32570,21475),
    (New-AxinUString 21344,20301), (New-AxinUString 27169,25311), (New-AxinUString 31354), (New-AxinUString 19981,28165,26970)
  )
  $visual = @(
    "image", "illustration", "character", "ip", "visual", "style", "shot", "scene", "prompt", "label", "figure",
    (New-AxinUString 22270), (New-AxinUString 37197,22270), (New-AxinUString 25554,30011), (New-AxinUString 35282,33394), (New-AxinUString 24418,35937),
    (New-AxinUString 30011,38754), (New-AxinUString 25552,31034,35789), (New-AxinUString 26631,27880)
  )

  return @(
    @{ Name = "judgement"; Words = $judgement },
    @{ Name = "evidence"; Words = $evidence },
    @{ Name = "workflow"; Words = $workflow },
    @{ Name = "audience"; Words = $audience },
    @{ Name = "risk"; Words = $risk },
    @{ Name = "visual"; Words = $visual }
  )
}

function Get-AxinKeywordScore {
  param(
    [string]$Text,
    [string[]]$Words
  )

  $score = 0
  foreach ($word in $Words) {
    if ($Text.IndexOf($word, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
      $score += 1
    }
  }
  return $score
}

function Get-AxinCategorySignals {
  param([string]$Text)

  $signals = @{}
  foreach ($set in (Get-AxinKeywordSets)) {
    $signals[$set.Name] = Get-AxinKeywordScore -Text $Text -Words $set.Words
  }
  return $signals
}

function Get-AxinDiagnosisItems {
  param(
    [hashtable]$Signals,
    [int]$ParagraphCount,
    [int]$CharCount
  )

  $strengths = @()
  $gaps = @()
  $rewrites = @()

  if ($Signals.judgement -ge 2) {
    $strengths += "The article contains explicit judgement or decision language."
  } else {
    $gaps += "The core judgement is weak or implicit."
    $rewrites += "Add one sentence that says what the reader should remember and why it matters."
  }

  if ($Signals.evidence -ge 2) {
    $strengths += "The article contains evidence, verification, result, or status language."
  } else {
    $gaps += "Evidence is thin; it may read like a plan or claim."
    $rewrites += "Add concrete proof: command output, screenshot, commit, metric, test result, or visible user outcome."
  }

  if ($Signals.workflow -ge 2) {
    $strengths += "The article has workflow or artifact signals that can become visual scenes."
  } else {
    $gaps += "The workflow is not concrete enough for strong illustration prompts."
    $rewrites += "Describe the input, transformation, output, and review step in plain words."
  }

  if ($Signals.audience -ge 1) {
    $strengths += "The article hints at a target audience or publishing context."
  } else {
    $gaps += "The target reader is not clear."
    $rewrites += "Name the reader: open-source user, builder, content creator, team reviewer, or future agent."
  }

  if ($Signals.risk -ge 1) {
    $strengths += "The article names risks, gaps, or common mistakes."
  } else {
    $gaps += "The article does not name enough tension, risk, or failure mode."
    $rewrites += "Add one contrast: what goes wrong without this workflow, and what changes after using it."
  }

  if ($Signals.visual -ge 1) {
    $strengths += "The article includes visual or prompt concepts."
  } else {
    $gaps += "The visual translation layer is not explicit."
    $rewrites += "Add what should be drawn and what should not be drawn."
  }

  if ($ParagraphCount -lt 3 -or $CharCount -lt 400) {
    $gaps += "The input is short; the diagnosis may be shallow."
    $rewrites += "Add more context before generating many images."
  }

  return [pscustomobject]@{
    Strengths = $strengths
    Gaps = $gaps
    RewriteActions = $rewrites | Select-Object -Unique
  }
}

function Get-AxinVerdict {
  param([int]$Score)

  if ($Score -ge 75) {
    return "ready"
  }
  if ($Score -ge 55) {
    return "usable_with_edits"
  }
  if ($Score -ge 35) {
    return "diagnose_before_prompts"
  }
  return "not_ready"
}

function Get-AxinArticleDiagnosis {
  param(
    [string]$ArticleText,
    [string]$Topic = "",
    [string]$SourcePath = "",
    [int]$ImageCount = 4
  )

  $paragraphs = Get-AxinParagraphs -Text $ArticleText
  $charCount = if ([string]::IsNullOrWhiteSpace($ArticleText)) { 0 } else { $ArticleText.Length }
  $signals = Get-AxinCategorySignals -Text $ArticleText
  $items = Get-AxinDiagnosisItems -Signals $signals -ParagraphCount $paragraphs.Count -CharCount $charCount

  $baseScore = 10
  $score = $baseScore
  $score += [Math]::Min(20, $signals.judgement * 5)
  $score += [Math]::Min(20, $signals.evidence * 4)
  $score += [Math]::Min(18, $signals.workflow * 4)
  $score += [Math]::Min(12, $signals.audience * 4)
  $score += [Math]::Min(10, $signals.risk * 3)
  $score += [Math]::Min(10, $signals.visual * 3)
  if ($paragraphs.Count -ge 5) { $score += 5 }
  if ($charCount -ge 800) { $score += 5 }
  if ($signals.risk -lt 2) { $score -= 8 }
  if ($signals.evidence -lt 3) { $score -= 10 }
  if ($signals.judgement -lt 3) { $score -= 8 }
  if ($signals.workflow -lt 3) { $score -= 6 }
  if ($signals.audience -lt 2) { $score -= 6 }
  if ($charCount -lt 600) { $score -= 8 }
  if ($paragraphs.Count -lt 4) { $score -= 8 }
  if ($signals.evidence -ge 3 -and $signals.workflow -ge 3 -and $charCount -ge 120 -and $score -lt 38) {
    $score = 38
  }
  if ($score -lt 0) { $score = 0 }
  if ($score -gt 100) { $score = 100 }

  $verdict = Get-AxinVerdict -Score $score
  $recommendedImageCount = $ImageCount
  if ($verdict -eq "not_ready") {
    $recommendedImageCount = 0
  } elseif ($verdict -eq "diagnose_before_prompts") {
    $recommendedImageCount = [Math]::Min(2, $ImageCount)
  } elseif ($verdict -eq "usable_with_edits") {
    $recommendedImageCount = [Math]::Min(4, $ImageCount)
  }

  $topParagraphs = @(
    $paragraphs |
      Sort-Object { Get-AxinKeywordScore -Text $_ -Words @("evidence", "workflow", "judgement", "result", "prompt", "README", "LLM", "risk", "proof", "asset") } -Descending |
      Select-Object -First 5 |
      ForEach-Object { Get-AxinShortText -Text $_ -MaxLength 220 }
  )

  return [pscustomobject]@{
    Topic = $Topic
    SourcePath = $SourcePath
    Score = $score
    Verdict = $verdict
    RecommendedImageCount = $recommendedImageCount
    ParagraphCount = $paragraphs.Count
    CharacterCount = $charCount
    Signals = [pscustomobject]@{
      judgement = $signals.judgement
      evidence = $signals.evidence
      workflow = $signals.workflow
      audience = $signals.audience
      risk = $signals.risk
      visual = $signals.visual
    }
    Strengths = $items.Strengths
    Gaps = $items.Gaps
    RewriteActions = $items.RewriteActions
    BestCandidateAnchors = $topParagraphs
  }
}

function Format-AxinDiagnosisMarkdown {
  param([pscustomobject]$Diagnosis)

  $lines = @(
    "# Content Diagnosis",
    "",
    "- Topic: $($Diagnosis.Topic)",
    "- Source path: $($Diagnosis.SourcePath)",
    "- Score: $($Diagnosis.Score) / 100",
    "- Verdict: $($Diagnosis.Verdict)",
    "- Recommended image count: $($Diagnosis.RecommendedImageCount)",
    "- Paragraphs: $($Diagnosis.ParagraphCount)",
    "- Characters: $($Diagnosis.CharacterCount)",
    "",
    "## Signal Scores",
    "",
    "- Judgement: $($Diagnosis.Signals.judgement)",
    "- Evidence: $($Diagnosis.Signals.evidence)",
    "- Workflow: $($Diagnosis.Signals.workflow)",
    "- Audience: $($Diagnosis.Signals.audience)",
    "- Risk: $($Diagnosis.Signals.risk)",
    "- Visual: $($Diagnosis.Signals.visual)",
    "",
    "## Verdict Meaning",
    "",
    "- ready: article can move into shot list and image prompts.",
    "- usable_with_edits: prompts can be generated, but revise the article before publishing.",
    "- diagnose_before_prompts: do not generate many images yet; clarify judgement, evidence, and workflow first.",
    "- not_ready: avoid image generation; the article is too thin or too vague.",
    "",
    "## Strengths",
    ""
  )

  if ($Diagnosis.Strengths.Count -gt 0) {
    $lines += ($Diagnosis.Strengths | ForEach-Object { "- $_" })
  } else {
    $lines += "- No strong assets detected yet."
  }

  $lines += @("", "## Gaps", "")
  if ($Diagnosis.Gaps.Count -gt 0) {
    $lines += ($Diagnosis.Gaps | ForEach-Object { "- $_" })
  } else {
    $lines += "- No major gaps detected by the heuristic diagnosis."
  }

  $lines += @("", "## Rewrite Actions", "")
  if ($Diagnosis.RewriteActions.Count -gt 0) {
    $lines += ($Diagnosis.RewriteActions | ForEach-Object { "- $_" })
  } else {
    $lines += "- Keep the article evidence-backed and make each visual scene carry one clear judgement."
  }

  $lines += @("", "## Best Candidate Anchors", "")
  if ($Diagnosis.BestCandidateAnchors.Count -gt 0) {
    $lines += ($Diagnosis.BestCandidateAnchors | ForEach-Object { "- $_" })
  } else {
    $lines += "- No candidate anchors found."
  }

  $lines += @(
    "",
    "## Gate",
    "",
    "Only move into image generation when the article has a clear judgement, concrete evidence, a visible workflow, and a reader who benefits from the result."
  )

  return $lines
}
