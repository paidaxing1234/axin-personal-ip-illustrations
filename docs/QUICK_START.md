# Quick Start

这份文档面向第一次打开仓库的开源用户。你不需要先安装 agent skill，也不需要先准备自己的 IP 形象；先用示例文章跑通一次，再替换成自己的文章。

## 你会得到什么

输入一篇 Markdown 或 TXT 文章，脚本会生成一个内容包：

```text
content-packages/<slug>/
├── article.md
├── content-diagnosis.md
├── analysis.md
├── illustration-shot-list.md
├── image-prompts.md
├── image-prompts.jsonl
├── distribution-plan.md
├── readme-snippet.md
├── publish-checklist.md
└── images/
```

这个仓库的核心不是直接替你发布内容，而是先判断文章是否值得资产化，再把文章分析成可审核、可复制、可批量生成图片的 prompt 包。

## 1. 跑通示例

在仓库根目录执行：

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\examples\sample-article.md `
  -Slug sample-article `
  -ImageCount 4 `
  -LanguageMode zh
```

生成后打开：

```text
content-packages/sample-article/content-diagnosis.md
content-packages/sample-article/image-prompts.md
```

你也可以先看脚本帮助：

```powershell
.\scripts\new-content-package.ps1 -Help
```

只做内容诊断，不生成 prompt：

```powershell
.\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md
```

可选：用 LLM 做更严格的语义审稿：

```powershell
$env:OPENAI_API_KEY = "<your key>"
.\scripts\analyze-article.ps1 `
  -ArticlePath .\examples\sample-article.md `
  -Semantic
```

## 2. 换成自己的文章

把你的文章保存成 Markdown 或 TXT，然后执行：

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -ImageCount 5 `
  -LanguageMode auto
```

如果没有指定 `-Slug`，脚本会从文章标题生成目录名。

如果你希望内容包里的 `content-diagnosis.md` 同时包含 LLM 语义审稿，可以加 `-Semantic`：

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -ImageCount 5 `
  -LanguageMode auto `
  -Semantic
```

## 3. 传入自己的 IP 形象

如果你已经有个人 IP 角色图、头像、设定图或参考图，把它作为角色锚点传入：

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -CharacterImagePath .\path\to\your-ip.png `
  -CharacterName "你的IP名" `
  -ImageCount 5 `
  -LanguageMode zh
```

脚本会把角色参考图复制到内容包的 `character-reference/` 目录，并在每条图片 prompt 里要求保留这个 IP 的身份、发型、脸型、衣服、气质和线稿风格。

## 4. 读输出文件

- `content-diagnosis.md`：文章资产化诊断，包含分数、结论、缺口、改写建议和推荐配图数量；使用 `-Semantic` 时会追加 LLM 语义审稿。
- `analysis.md`：文章标题、段落、语言判断、认知锚点。
- `illustration-shot-list.md`：每张图应该表达什么、放什么元素、角色做什么动作。
- `image-prompts.md`：适合复制到生图工具的完整 prompt。
- `image-prompts.jsonl`：适合接入 CLI 或批处理的结构化任务。
- `distribution-plan.md`：中文和英文渠道如何消费同一个项目经验。
- `publish-checklist.md`：发布前检查，避免把计划、mock 或占位写成完成。

## 5. 生成图片

这个仓库先生成可审核的配图 prompt。你可以把 `image-prompts.md` 里的每条 prompt 复制到自己的生图工具里，也可以让支持图片生成的 agent 读取 `image-prompts.jsonl` 后逐张生成。

建议每次只生成一张图并检查：

- 角色是否参与核心动作，而不是站在旁边当装饰。
- 画面是否保持白底、黑色手绘线稿和大量留白。
- 文字是否足够少。
- 这张图是否真的表达了文章里的一个判断、流程、证据或坑。

## 常见问题

### PowerShell 不让我运行脚本怎么办？

如果 Windows 提示脚本被执行策略阻止，可以在当前终端临时放开本进程：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

如果你是通过浏览器下载 ZIP 后解压，文件可能带有网络来源标记，可以在仓库目录执行：

```powershell
Get-ChildItem -Recurse -File | Unblock-File
```

### Git clone 很慢或下载 ZIP 很慢怎么办？

可以先确认远程文件是否可访问，再只下载需要的文件测试脚本。最少需要这些文件和目录：`scripts/`、`examples/sample-article.md`、`axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png`。完整使用仍建议下载整个仓库，因为 README、docs、skill 和示例资产会一起更新。

### 我必须使用阿鑫吗？

不必须。默认角色是阿鑫 / Axin，方便你直接跑通流程。传入 `-CharacterImagePath` 和 `-CharacterName` 后，脚本会把你的 IP 形象作为角色锚点。

### 这个工具会直接生成 PNG 吗？

不会。`new-content-package.ps1` 负责文章诊断、文章分析和 prompt 包生成。图片生成留给你自己的生图工具或 agent，这样你可以先审查诊断、shot list 和 prompt，再花生成成本。

### 中文和英文是不是互相翻译？

不是。中文内容更适合讲过程、复盘、踩坑和判断；英文内容更适合讲仓库、工作流、可复用性和 LLM 可发现性。`distribution-plan.md` 会把同一篇文章拆成两套语境，而不是逐字翻译。

### 生成的 prompt 太泛怎么办？

先改文章。这个脚本从文章里抓取认知锚点，如果原文只有口号，没有证据、取舍、流程或具体动作，prompt 也会变空。更好的输入是：真实项目、运行结果、错误修正、发布过程、设计取舍和复盘判断。

### 诊断结论是什么意思？

- `ready`：可以进入 shot list 和图片 prompt。
- `usable_with_edits`：可以生成 prompt，但发布前要补文章。
- `diagnose_before_prompts`：先改文章，不建议生成太多图。
- `not_ready`：不要生成图，先补判断、证据、流程和读者。

### LLM 语义审稿和默认诊断有什么区别？

默认诊断是离线启发式检查，不需要 API key，适合快速判断文章有没有判断、证据、流程、读者和视觉锚点。`-Semantic` 会调用 OpenAI Responses API，用结构化 JSON 输出进一步判断文章是否只有口号、是否混淆完成和计划、是否值得生成配图。

### 语义审稿提示 `OPENAI_API_KEY is not set` 怎么办？

这表示你启用了 `-Semantic`，但当前环境没有 OpenAI API key。可以先去掉 `-Semantic` 使用离线诊断，也可以在当前 PowerShell 会话设置：

```powershell
$env:OPENAI_API_KEY = "<your key>"
```

### 我想把它安装成 skill 怎么办？

跑通脚本之后再安装更稳：

```powershell
.\scripts\install-local-skill.ps1
```

更多平台入口见 `docs/MULTI_PLATFORM.md`。
