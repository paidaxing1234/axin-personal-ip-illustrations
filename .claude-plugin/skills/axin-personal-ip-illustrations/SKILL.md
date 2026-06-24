---
name: axin-personal-ip-illustrations
description: 生成“阿鑫”个人 IP 风格的中英文内容配图。适用于个人品牌、公开构建、项目复盘、AI 工作流、内容资产化、GitHub README、公众号、知乎、Notion 文档等场景；默认使用阿鑫 IP、纯白手绘、少量红橙蓝手写批注，把经验、判断、流程、状态或隐喻转成清爽怪诞的 16:9 正文配图。
version: 2.0.0
author: paidaxing1234
license: MIT
platforms: [codex, hermes, claude-code, cursor, windsurf, cline, opencode, generic-agents]
metadata:
  hermes:
    tags: [illustration, personal-ip, imagegen, chinese-content, bilingual, geo, multi-platform]
    related_skills: [architecture-diagram, hermes-agent-skill-authoring]
---

# 阿鑫个人 IP 配图

## 核心定位

为中文和英文个人 IP 内容设计、规划和生成配图。目标不是做商业插画、PPT 信息图、可爱头像或通用吉祥物，而是把内容里的关键判断、流程、状态、证据链或资产化动作，变成一张清爽、怪诞、有记忆点的手绘解释图。

默认视觉 IP 是“阿鑫”：一个黑发、眼镜、hoodie 的真人手绘内容操作员。阿鑫安静、认真、冷静，有一点轻微荒诞感，负责把真实项目、运行证据、复盘和输出接到中文内容、英文 README、`llms.txt` 和多平台 agent 入口。阿鑫不是非人类吉祥物、工具箱角色、印章角色或抽象怪物。

用户也可以传入自己的 IP 形象图或角色设定。此时把用户 IP 作为角色锚点，仍然沿用“白底、黑色手绘线稿、少量红橙蓝批注、角色参与核心动作”的方法；不要把用户 IP 只贴在画面边缘当装饰。

## 先读这些参考

按任务需要读取：

- `references/style-dna.md`：风格 DNA、颜色、文字、禁忌。
- `references/axin-ip.md`：阿鑫 IP 的形象、性格、动作库和禁忌。
- `references/composition-patterns.md`：结构类型、原创隐喻方法和反复刻规则。
- `references/platform-adapters.md`：Codex、Hermes、Claude Code 和通用 agent 平台的使用方式。
- `references/workflow.md`：从文章到图片资产的完整流程。
- `references/prompt-template.md`：单张生图提示词模板。
- `references/qa-checklist.md`：生成后检查和迭代规则。
- `assets/examples/`：只作视觉校准，不要照抄构图。

## 工作流

### 1. 消化内容

先读用户给的文章、项目复盘、README、Notion、截图或主题。提炼：

- 这段内容最想建立的个人 IP 判断是什么。
- 哪些地方承担认知转折。
- 哪些地方体现“真实做过”，而不是包装出来的口号。
- 哪些地方适合画成流程、状态、证据链或隐喻。
- 哪些地方只适合文字，不需要配图。
- 如果用户传入 IP 形象图，哪些画面最适合让这个 IP 亲自做动作，而不是当头像。

不要平均配图。优先选择“认知锚点”：核心判断、输入输出闭环、前后对比、常见坑、资产沉淀、发布承接、复利飞轮、证据质检。

### 2. 先出 shot list 或内容包

如果用户只是要求“分析怎么配图 / 做配图策略 / 规划”，先给 shot list。每张图写清楚：

- 放在哪个段落后。
- 图的主题。
- 核心意思。
- 结构类型。
- 阿鑫在图里做什么。
- 建议元素。
- 建议中英文标注词。

默认 4-8 张。短文 1-3 张，长文也不要轻易超过 9 张。

如果用户在本仓库内工作，并要求“输入文章 / 自动分析文章 / 生成提示词 / 传入自己的 IP 形象”，优先使用：

```powershell
.\scripts\new-content-package.ps1 -ArticlePath <article.md> -CharacterImagePath <ip.png> -CharacterName "<IP名>" -ImageCount 4
```

它会生成 `analysis.md`、`illustration-shot-list.md`、`image-prompts.md`、`image-prompts.jsonl`、`distribution-plan.md` 和 `publish-checklist.md`。

### 3. 单张生成

如果用户明确要求“生成 / 输出 / 做图 / 帮我生成”，不要停下来等确认；使用 `imagegen` 每张单独生成，不要把多张图拼在一张里。

每张图只讲一个核心结构。提示词必须包含：

- 16:9 横版正文配图，角色锚点图除外。
- 纯白背景。
- 黑色手绘线稿。
- 少量红色、橙色、蓝色手写批注。
- 大量留白。
- 阿鑫作为核心动作主体，保持黑发、眼镜、hoodie、真人手绘外形。
- 禁止 PPT、商业插画、幼稚可爱、复杂架构、左上角类型标题。

### 4. 中英文切换

默认按用户输入语言输出。如果用户要求英文、GitHub 国际化或双语发布：

- 中文 README、公众号、知乎：优先中文短标注。
- 英文 README、GitHub Pages、海外受众：优先英文短标注。
- 双语图：只保留极少双语标签，不要把一张图写成翻译对照表。
- 角色名中文使用“阿鑫”，英文使用“Axin”。
- 中文分发面向公众号、知乎、即刻、小红书；英文分发面向 GitHub、README、Hacker News、X、Medium。价值不是翻译，而是同一份经验被两个语境分别消费。

### 5. 检查与迭代

生成后检查 `references/qa-checklist.md`。如果出现这些问题，优先重生成或局部编辑：

- 阿鑫只是装饰。
- 画面太满。
- 太像流程图或 PPT。
- 文字太多或错字严重。
- 左上角出现“Workflow / 系统架构图 / 常见坑 / 路线图”等标题。
- 画风太可爱、幼稚、商业。
- 背景不是干净白底。
- 新图和旧示例构图重复。

### 6. 保存交付

如果用户在 workspace 内工作，把最终图复制到：

```text
assets/<topic-slug>-illustrations/
```

按顺序命名：

```text
01-topic-name.png
02-topic-name.png
```

保留原始生成文件，不要覆盖已有资产，除非用户明确要求替换。

## 输出口径

生成前的策略输出要短而准。生成后的交付包含：

- 生成了几张。
- 每张图的用途。
- 保存路径。
- 哪些图最稳，哪些图是可选。
- 真实运行了哪些校验。

不要长篇解释风格理论；让图自己说话。
