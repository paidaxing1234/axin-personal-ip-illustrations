# Axin Personal IP Illustration Workflow

> A hand-drawn personal IP illustration workflow for mainstream agent tools, turning real project work, retrospectives, and content systems into reusable Axin-style visual assets.

[中文](README.md) · [English](README.en.md) · [LLM entry](llms.txt) · [Platform guide](docs/MULTI_PLATFORM.md) · [Content OS](docs/AXIN_CONTENT_OS.md) · [Character library](docs/CHARACTER_LIBRARY.md) · [Cases](cases/README.md)

This is not an avatar pack or a slide template. It is an installable agent skill for turning personal-brand writing, public-build notes, project retrospectives, AI workflow content, and GitHub README material into clean, strange, white-background article illustrations.

The default recurring IP is **Axin / 阿鑫**: a hand-drawn human content operator with black hair, round glasses, and a hoodie. Axin is quiet, practical, and slightly deadpan. He is not a mascot, monster, stamp, or toolbox character. Axin must perform the core action in each image, such as wiring, routing, checking, labeling, organizing files, publishing, or recycling.

## Axin IP Assets

### Axin Main Visual

![Axin bilingual workflow main visual](axin-personal-ip-illustrations/assets/examples/01-axin-human-bilingual-workflow.png)

### Axin IP Asset Board

![Axin IP asset board](axin-personal-ip-illustrations/assets/examples/06-axin-ip-asset-board.png)

### Axin Character Anchor

![Axin human character anchor](axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png)

## Workflow Examples

### Repository Review

![Axin repository review desk](axin-personal-ip-illustrations/assets/examples/03-axin-human-repo-review-desk.png)

### Agent Discovery

![Axin agent discovery flow](axin-personal-ip-illustrations/assets/examples/04-axin-human-geo-agent-discovery.png)

### Content Reuse Workbench

![Axin content reuse workbench](axin-personal-ip-illustrations/assets/examples/05-axin-human-content-reuse-workbench.png)

## Good Fits

- Chinese articles, WeChat posts, Zhihu answers, Notion notes, GitHub README visuals, and project retrospectives.
- Public-building stories where real work, evidence, reuse, and publishing need a memorable visual metaphor.
- Personal IP systems for AI workflows, solo products, content compounding, product validation, and open-source packaging.
- Agent workflows that need stable prompts, style rules, QA checks, and repeatable output paths.

Not a good fit:

- Commercial key visuals.
- Dense slide-style infographics.
- Cute mascot sticker packs.
- Text-heavy course pages.
- Strictly editable vector diagrams.

## Quick Start

Install the local skill:

```powershell
.\scripts\install-local-skill.ps1
```

Install into an external skill directory:

```powershell
.\scripts\install-hermes-skill.ps1
```

Sync the plugin snapshot:

```powershell
.\scripts\sync-platform-packages.ps1
```

Use in an agent session:

```text
Use $axin-personal-ip-illustrations to design and generate 4 Axin-style article illustrations for this post.
Requirements: 16:9, pure white background, black hand-drawn line art, sparse red/orange/blue handwritten labels.

<paste article>
```

Turn an article and your own IP character reference into a reusable prompt package:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\articles\my-post.md `
  -CharacterImagePath .\assets\my-ip.png `
  -CharacterName "Your IP" `
  -ImageCount 5 `
  -LanguageMode en
```

The command writes `analysis.md`, `illustration-shot-list.md`, `image-prompts.md`, `image-prompts.jsonl`, `distribution-plan.md`, and `publish-checklist.md`. The point is not literal translation; it turns one article into Chinese and English publishing assets.

Plan only:

```text
Use $axin-personal-ip-illustrations. Do not generate images yet.
Analyze this article and produce a 5-image shot list. For each image, include theme, core idea, structure type, what Axin does, and suggested labels.
```

## Tool Entrypoints

This repository keeps installer scripts, rules files, plugin snapshots, and generic agent entrypoints. The front-page README no longer exposes a platform-name matrix, because browser translation can rewrite product names. See [docs/MULTI_PLATFORM.md](docs/MULTI_PLATFORM.md) for the protected platform guide.

## Generation Rules

- Default canvas: 16:9 horizontal article image. Character anchors may be 1:1.
- Pure white background, no paper texture, beige tint, shadow, or gradient.
- Black hand-drawn line art, sparse orange for paths, red for warnings/results, blue for system feedback.
- One image explains one judgement, workflow, state, or metaphor.
- Labels should be short. Use Chinese, English, or very sparse bilingual labels depending on the publishing context.
- Axin must remain the human hand-drawn character with black hair, glasses, and a hoodie, and must participate in the core action. If the image still works after removing Axin, the image fails.

## Validation

```powershell
.\scripts\validate-repo.ps1
```

The validator checks required files, example images, skill metadata, platform snapshots, bilingual README entries, and local install scripts.

## License

MIT License. See [LICENSE](LICENSE).
