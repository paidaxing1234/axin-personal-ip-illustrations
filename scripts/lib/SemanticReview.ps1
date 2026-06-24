function Get-AxinSemanticApiKey {
  param([string]$ApiKeyEnv = "OPENAI_API_KEY")

  if ([string]::IsNullOrWhiteSpace($ApiKeyEnv)) {
    $ApiKeyEnv = "OPENAI_API_KEY"
  }

  $value = [Environment]::GetEnvironmentVariable($ApiKeyEnv, "Process")
  if ([string]::IsNullOrWhiteSpace($value)) {
    $value = [Environment]::GetEnvironmentVariable($ApiKeyEnv, "User")
  }
  if ([string]::IsNullOrWhiteSpace($value)) {
    $value = [Environment]::GetEnvironmentVariable($ApiKeyEnv, "Machine")
  }

  if ([string]::IsNullOrWhiteSpace($value)) {
    throw "$ApiKeyEnv is not set. Run heuristic mode without -Semantic, or set the environment variable before using LLM semantic review."
  }

  return $value
}

function Get-AxinSemanticPrompt {
  param(
    [string]$ArticleText,
    [string]$Topic = "",
    [string]$SourcePath = "",
    [int]$ImageCount = 4
  )

@"
You are a strict semantic editor for an open-source article-to-illustration workflow.

Review the article as a public-facing content asset, not as a private brainstorm. Your job is to decide whether it deserves illustration prompts and what must be fixed first.

Rules:
- Do not flatter.
- Reject slogan-only, plan-only, or vague inspirational content.
- Separate done, partial, stub, estimate, and missing evidence.
- Do not treat image generation, screenshots, or polished wording as proof.
- Recommend zero images when the article lacks a clear judgement, evidence, workflow, and reader value.
- Prefer fewer strong scenes over many decorative images.
- If the user provided a personal IP character, the character must perform the core action rather than decorate the edge.
- Chinese and English distribution are different contexts, not literal translation.
- Keep the review useful for open-source users who will run scripts and inspect files.

Return structured JSON that matches the API schema. Use one of these verdicts exactly:
- ready
- usable_with_edits
- diagnose_before_prompts
- not_ready

Keep every field specific and short. For best_scenes, cite a short article phrase or summarize the evidence instead of inventing a new claim.

Topic: $Topic
Source path: $SourcePath
Requested image count: $ImageCount

Article:
<<<ARTICLE
$ArticleText
ARTICLE
"@
}

function Get-AxinResponseText {
  param([object]$Response)

  if ($null -eq $Response) {
    return ""
  }

  if ($Response.PSObject.Properties.Name -contains "output_text" -and -not [string]::IsNullOrWhiteSpace($Response.output_text)) {
    return [string]$Response.output_text
  }

  $parts = @()
  if ($Response.PSObject.Properties.Name -contains "output") {
    foreach ($item in @($Response.output)) {
      if ($null -eq $item) { continue }
      if ($item.PSObject.Properties.Name -contains "content") {
        foreach ($content in @($item.content)) {
          if ($null -eq $content) { continue }
          if ($content.PSObject.Properties.Name -contains "text" -and -not [string]::IsNullOrWhiteSpace($content.text)) {
            $parts += [string]$content.text
          }
        }
      }
    }
  }

  if ($parts.Count -gt 0) {
    return ($parts -join [Environment]::NewLine)
  }

  if ($Response.PSObject.Properties.Name -contains "choices") {
    $choice = @($Response.choices) | Select-Object -First 1
    if ($choice -and $choice.message -and $choice.message.content) {
      return [string]$choice.message.content
    }
  }

  return ($Response | ConvertTo-Json -Depth 12)
}

function ConvertFrom-AxinSemanticJson {
  param([string]$Text)

  if ([string]::IsNullOrWhiteSpace($Text)) {
    throw "LLM returned an empty response."
  }

  $candidate = $Text.Trim()
  if ($candidate -match '(?s)```(?:json)?\s*(.*?)\s*```') {
    $candidate = $Matches[1].Trim()
  }

  if (-not $candidate.StartsWith("{")) {
    $start = $candidate.IndexOf("{")
    $end = $candidate.LastIndexOf("}")
    if ($start -ge 0 -and $end -gt $start) {
      $candidate = $candidate.Substring($start, $end - $start + 1)
    }
  }

  return $candidate | ConvertFrom-Json
}

function Invoke-AxinSemanticReview {
  param(
    [string]$ArticleText,
    [string]$Topic = "",
    [string]$SourcePath = "",
    [int]$ImageCount = 4,
    [string]$Model = "gpt-5.5",
    [string]$ApiBase = "https://api.openai.com/v1",
    [string]$ApiKeyEnv = "OPENAI_API_KEY",
    [int]$TimeoutSec = 120
  )

  if ([string]::IsNullOrWhiteSpace($ArticleText)) {
    throw "No article content provided for semantic review."
  }

  $apiKey = Get-AxinSemanticApiKey -ApiKeyEnv $ApiKeyEnv
  $base = $ApiBase.TrimEnd("/")
  $uri = "$base/responses"
  $prompt = Get-AxinSemanticPrompt -ArticleText $ArticleText -Topic $Topic -SourcePath $SourcePath -ImageCount $ImageCount
  $schema = [ordered]@{
    type = "object"
    additionalProperties = $false
    required = @(
      "verdict",
      "score",
      "core_judgement",
      "reader",
      "evidence_assessment",
      "workflow_assessment",
      "visual_asset_assessment",
      "gaps",
      "rewrite_actions",
      "illustration_recommendation"
    )
    properties = [ordered]@{
      verdict = [ordered]@{
        type = "string"
        enum = @("ready", "usable_with_edits", "diagnose_before_prompts", "not_ready")
      }
      score = [ordered]@{
        type = "integer"
      }
      core_judgement = [ordered]@{
        type = "string"
      }
      reader = [ordered]@{
        type = "string"
      }
      evidence_assessment = [ordered]@{
        type = "string"
      }
      workflow_assessment = [ordered]@{
        type = "string"
      }
      visual_asset_assessment = [ordered]@{
        type = "string"
      }
      gaps = [ordered]@{
        type = "array"
        items = [ordered]@{ type = "string" }
      }
      rewrite_actions = [ordered]@{
        type = "array"
        items = [ordered]@{ type = "string" }
      }
      illustration_recommendation = [ordered]@{
        type = "object"
        additionalProperties = $false
        required = @("recommended_image_count", "best_scenes")
        properties = [ordered]@{
          recommended_image_count = [ordered]@{
            type = "integer"
          }
          best_scenes = [ordered]@{
            type = "array"
            items = [ordered]@{
              type = "object"
              additionalProperties = $false
              required = @("title", "article_evidence", "why_visual", "risk")
              properties = [ordered]@{
                title = [ordered]@{ type = "string" }
                article_evidence = [ordered]@{ type = "string" }
                why_visual = [ordered]@{ type = "string" }
                risk = [ordered]@{ type = "string" }
              }
            }
          }
        }
      }
    }
  }

  $body = [ordered]@{
    model = $Model
    input = $prompt
    store = $false
    max_output_tokens = 1800
    text = [ordered]@{
      format = [ordered]@{
        type = "json_schema"
        name = "axin_semantic_review"
        strict = $true
        schema = $schema
      }
    }
  }

  if ($Model -match "^gpt-5") {
    $body.reasoning = [ordered]@{
      effort = "low"
    }
    $body.text.verbosity = "low"
  }

  $headers = @{
    Authorization = "Bearer $apiKey"
    "Content-Type" = "application/json"
  }

  try {
    $response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body ($body | ConvertTo-Json -Depth 12) -TimeoutSec $TimeoutSec
  }
  catch {
    $status = ""
    if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
      $statusCode = [int]$_.Exception.Response.StatusCode
      $status = " HTTP $statusCode"
    }
    throw "Semantic review API request failed$status. Check -ApiBase, -SemanticModel, and the $ApiKeyEnv value. The key value is never printed."
  }

  $rawText = Get-AxinResponseText -Response $response

  try {
    $parsed = ConvertFrom-AxinSemanticJson -Text $rawText
    return [pscustomobject]@{
      Status = "parsed"
      Model = $Model
      ApiBase = $base
      ReviewedAt = (Get-Date).ToString("s")
      Verdict = $parsed.verdict
      Score = [int]$parsed.score
      CoreJudgement = $parsed.core_judgement
      Reader = $parsed.reader
      EvidenceAssessment = $parsed.evidence_assessment
      WorkflowAssessment = $parsed.workflow_assessment
      VisualAssetAssessment = $parsed.visual_asset_assessment
      Gaps = @($parsed.gaps)
      RewriteActions = @($parsed.rewrite_actions)
      IllustrationRecommendation = $parsed.illustration_recommendation
      RawResponse = $rawText
    }
  }
  catch {
    return [pscustomobject]@{
      Status = "raw_unparsed"
      Model = $Model
      ApiBase = $base
      ReviewedAt = (Get-Date).ToString("s")
      Warning = "LLM response was not valid JSON: $($_.Exception.Message)"
      Verdict = ""
      Score = $null
      CoreJudgement = ""
      Reader = ""
      EvidenceAssessment = ""
      WorkflowAssessment = ""
      VisualAssetAssessment = ""
      Gaps = @()
      RewriteActions = @("Rerun semantic review or inspect RawResponse manually.")
      IllustrationRecommendation = $null
      RawResponse = $rawText
    }
  }
}

function Format-AxinSemanticReviewMarkdown {
  param([pscustomobject]$Review)

  if ($null -eq $Review) {
    return @()
  }

  $lines = @(
    "## Semantic Review",
    "",
    "- Status: $($Review.Status)",
    "- Model: $($Review.Model)",
    "- Reviewed at: $($Review.ReviewedAt)"
  )

  if (-not [string]::IsNullOrWhiteSpace($Review.Warning)) {
    $lines += "- Warning: $($Review.Warning)"
  }

  if (-not [string]::IsNullOrWhiteSpace($Review.Verdict)) {
    $lines += "- Verdict: $($Review.Verdict)"
  }
  if ($null -ne $Review.Score) {
    $lines += "- Score: $($Review.Score) / 100"
  }

  $lines += @(
    "",
    "### Core Judgement",
    ""
  )
  if ([string]::IsNullOrWhiteSpace($Review.CoreJudgement)) {
    $lines += "- Not provided."
  } else {
    $lines += "- $($Review.CoreJudgement)"
  }

  $lines += @(
    "",
    "### Reader",
    ""
  )
  if ([string]::IsNullOrWhiteSpace($Review.Reader)) {
    $lines += "- Not provided."
  } else {
    $lines += "- $($Review.Reader)"
  }

  $lines += @(
    "",
    "### Evidence Assessment",
    ""
  )
  if ([string]::IsNullOrWhiteSpace($Review.EvidenceAssessment)) {
    $lines += "- Not provided."
  } else {
    $lines += "- $($Review.EvidenceAssessment)"
  }

  $lines += @(
    "",
    "### Workflow Assessment",
    ""
  )
  if ([string]::IsNullOrWhiteSpace($Review.WorkflowAssessment)) {
    $lines += "- Not provided."
  } else {
    $lines += "- $($Review.WorkflowAssessment)"
  }

  $lines += @(
    "",
    "### Visual Asset Assessment",
    ""
  )
  if ([string]::IsNullOrWhiteSpace($Review.VisualAssetAssessment)) {
    $lines += "- Not provided."
  } else {
    $lines += "- $($Review.VisualAssetAssessment)"
  }

  $lines += @(
    "",
    "### Gaps",
    ""
  )

  if ($Review.Gaps.Count -gt 0) {
    $lines += ($Review.Gaps | ForEach-Object { "- $_" })
  } else {
    $lines += "- No semantic gaps returned."
  }

  $lines += @("", "### Rewrite Actions", "")
  if ($Review.RewriteActions.Count -gt 0) {
    $lines += ($Review.RewriteActions | ForEach-Object { "- $_" })
  } else {
    $lines += "- No rewrite actions returned."
  }

  $lines += @("", "### Illustration Recommendation", "")
  if ($null -ne $Review.IllustrationRecommendation) {
    $count = $Review.IllustrationRecommendation.recommended_image_count
    $lines += "- Recommended image count: $count"
    $scenes = @($Review.IllustrationRecommendation.best_scenes)
    if ($scenes.Count -gt 0) {
      foreach ($scene in $scenes) {
        $lines += ""
        $lines += "#### $($scene.title)"
        $lines += ""
        $lines += "- Article evidence: $($scene.article_evidence)"
        $lines += "- Why visual: $($scene.why_visual)"
        $lines += "- Risk: $($scene.risk)"
      }
    }
  } else {
    $lines += "- No illustration recommendation returned."
  }

  if ($Review.Status -eq "raw_unparsed") {
    $lines += @(
      "",
      "### Raw Response",
      "",
      '```text',
      $Review.RawResponse,
      '```'
    )
  }

  return $lines
}
