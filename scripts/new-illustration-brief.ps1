param(
  [Parameter(Mandatory = $true)]
  [string]$Topic,

  [int]$Count = 4,

  [string]$Out = "briefs/illustration-brief.md"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$outPath = Join-Path $repoRoot $Out
$outDir = Split-Path -Parent $outPath
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$items = for ($i = 1; $i -le $Count; $i++) {
@"
## $i. 待命名

- 主题：$Topic
- 核心意思：
- 结构类型：内容工坊 / 证据质检 / 前后对比 / 资产分层 / 发布路径 / 复利飞轮 / 角色状态 / 小漫画分镜
- 阿鑫动作：
- 主物件：
- 中英文标注：
- 生成后 QA：

"@
}

$content = @"
# 阿鑫配图 Brief

- 主题：$Topic
- 目标张数：$Count
- 输出目录：assets/<topic-slug>-illustrations/

$($items -join "`n")
## 生成提示

Use `$axin-personal-ip-illustrations 根据上面的 brief 逐张生成阿鑫个人 IP 正文配图。每张图单独生成，16:9 横版，纯白背景，少量红橙蓝手写批注；按发布场景选择中文、英文或极少量双语标注。
"@

Set-Content -LiteralPath $outPath -Value $content -Encoding UTF8
Write-Host "Created brief at $outPath"
