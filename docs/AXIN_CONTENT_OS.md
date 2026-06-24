# 阿鑫内容操作系统

## 定位

阿鑫不只是配图角色，而是一套把真实项目变成内容资产的操作系统。

这套系统的核心输入是真实项目、运行记录、代码改动、截图、复盘和判断；核心输出不是一张好看的图，而是一组可以发布、复用、被搜索和被 agent 理解的资产。

如果你是第一次使用这个仓库，先读 `docs/QUICK_START.md`，用 `examples/sample-article.md` 跑通一次，再替换成自己的文章和 IP 形象图。

## 一次完整循环

1. 真实项目：项目目录、README、脚本、截图、运行结果、提交记录。
2. 证据提取：哪些东西真的跑过，哪些只是计划，哪些仍是缺口。
3. 判断沉淀：这次项目说明了什么，踩了什么坑，做对了什么取舍。
4. 内容诊断：先判断文章有没有清楚判断、证据、流程、读者、风险和视觉可转译性。
5. 内容包生成：文章分析、认知锚点、shot list、生图 prompt、双语分发计划、发布 checklist。
6. 视觉表达：用真人阿鑫或用户传入的 IP 形象，把一个关键流程、状态或判断画成白底手绘图。
7. 双语发布：中文内容讲过程和复盘，英文入口讲工具、仓库、使用方式和 LLM 可发现性。
8. 回收复用：把这次内容包放进 `cases/`，以后作为案例、prompt 样本和资产库。

## 标准内容包

每个项目建议生成一个目录：

```text
content-packages/<project-slug>/
├── article.md
├── content-diagnosis.md
├── analysis.md
├── brief.md
├── evidence.md
├── zh-draft.md
├── en-brief.md
├── illustration-shot-list.md
├── image-prompts.md
├── image-prompts.jsonl
├── distribution-plan.md
├── readme-snippet.md
├── metadata.json
├── character-reference/
├── images/
└── publish-checklist.md
```

先做内容诊断：

```powershell
.\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md
```

完整生成内容包：

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\articles\my-post.md `
  -CharacterImagePath .\assets\my-ip.png `
  -CharacterName "你的IP名" `
  -ImageCount 5 `
  -LanguageMode zh
```

也可以只建空包：

```powershell
.\scripts\new-content-package.ps1 -Topic "项目名或主题" -Slug "project-slug"
```

新的核心输入是文章和 IP 形象。脚本会本地读取文章，先诊断判断、证据、流程、读者、风险和视觉可转译性，再提取标题、段落、认知锚点、分发语境，生成几张正文配图的 prompt。它不负责直接把所有图生完，而是先给出可审核、可复制、可迭代的提示词包。

## 中英文分发

同一篇文章不要做逐字翻译。中文侧重点是过程、复盘、踩坑和判断；英文侧重点是仓库、流程、可复用性和 LLM 可发现性。

- 中文：公众号、知乎、即刻、小红书。
- 英文：GitHub、README、Hacker News、X、Medium。
- 共同资产：文章分析、shot list、生图 prompt、IP 形象锚点、发布 checklist。

## 质量门槛

- 不把计划写成完成。
- 不把 mock 写成实测。
- 不跳过 `content-diagnosis.md`；如果结论是 `not_ready`，先改文章再生图。
- 不把图片当装饰；每张图必须表达一个判断或流程。
- 不让阿鑫或自定义 IP 变成吉祥物；角色必须参与核心动作。
- 不把中文和英文入口割裂；它们应该来自同一套真实项目资产。
- 不把分发当翻译；中文和英文应该按各自语境重写。
- 每次发布前运行 `.\scripts\validate-repo.ps1`。

## 拓展路线

- 角色资产库：稳定阿鑫的角度、姿态、动作和表情。
- 案例库：把每次真实项目包装成可复用案例。
- CLI 内容包：把文章、README、复盘和配图 brief 变成标准产物。
- GitHub Pages：把仓库展示成阿鑫工作台，而不是普通说明页。
- 视频分镜：把内容包里的 shot list 进一步转成短视频脚本。
