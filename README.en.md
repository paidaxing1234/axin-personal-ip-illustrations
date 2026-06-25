# Axin Personal IP Illustration Workflow

> Paste an article into an agent conversation. If image generation is available, generate the images. If not, return copyable prompts.

[中文](README.md) · [English](README.en.md) · [Quick Start](docs/QUICK_START.en.md) · [LLM entry](llms.txt) · [Content OS](docs/AXIN_CONTENT_OS.md) · [Character library](docs/CHARACTER_LIBRARY.md) · [Cases](cases/README.md)

This is not an avatar pack or a slide template. It is an article-to-illustration workflow for open-source builders and content creators: reference the skill in a conversation, paste an article, let the agent decide how many images are useful, then either generate images directly or return copyable prompts when no image tool is available.

The default recurring IP is **Axin / 阿鑫**: a hand-drawn human content operator with black hair, round glasses, and a hoodie. You can also pass your own IP character reference image and use this workflow with your own visual identity.

## Use It In A Conversation

In any agent that supports skills, start with:

```text
Use $axin-personal-ip-illustrations
Here is my article. First decide how many illustrations it deserves.
If you have image generation, generate the images directly.
If not, return complete prompts for each image.

<paste article>
```

If you have your own IP character image, attach it and say:

```text
Use $axin-personal-ip-illustrations
Use my attached IP character as the reference instead of default Axin.
Analyze the article and create 4 article illustrations.
If image generation is available, generate them. Otherwise return prompts.

<paste article>
```

Expected output:

- Recommended image count.
- Where each image belongs in the article.
- What each image expresses.
- Generated image files when an image tool is available.
- Copyable prompts when no image tool is available.

For Douyin, Xiaohongshu, or short-form carousel posts, ask for a `9:16 vertical carousel`. Agents with `image_gen` should call `image_gen` once per card. Return prompts only when no callable image generation tool is available.

## Optional CLI Trial

The CLI is for batch production, saved content packages, and automation. From the repository root, run:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\examples\sample-article.md `
  -Slug sample-article `
  -ImageCount 4 `
  -LanguageMode en
```

Then open:

```text
content-packages/sample-article/content-diagnosis.md
content-packages/sample-article/image-prompts.md
```

You will get a content diagnosis first, then four complete illustration prompts plus `analysis.md`, `illustration-shot-list.md`, `distribution-plan.md`, and `publish-checklist.md`. See [docs/QUICK_START.en.md](docs/QUICK_START.en.md) for the full first-run guide.

## Diagnose Before Prompting

If you only want to check whether an article is ready for visual assets:

```powershell
.\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md
```

It reports `Score`, `Verdict`, `Gaps`, `Rewrite Actions`, and `Recommended image count`. Vague inputs can return `not_ready`, so the workflow does not turn slogans into polished-looking assets.

## Optional LLM Semantic Review

The default diagnosis runs offline. When you want stricter semantic judgement, enable the OpenAI-backed review:

```powershell
$env:OPENAI_API_KEY = "<your key>"
.\scripts\analyze-article.ps1 `
  -ArticlePath .\examples\sample-article.md `
  -Semantic
```

The semantic review checks whether the article is slogan-only, whether it separates `done / partial / stub`, whether evidence is strong enough, and whether the article deserves illustration prompts. You can also enable it while creating a full package:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -ImageCount 5 `
  -LanguageMode auto `
  -Semantic
```

## Use Your Own Article And IP

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -CharacterImagePath .\path\to\your-ip.png `
  -CharacterName "Your IP" `
  -ImageCount 5 `
  -LanguageMode auto
```

The script copies the character reference into `character-reference/` and tells each image prompt to preserve the same IP identity while making the character perform the core action.

Show help:

```powershell
.\scripts\new-content-package.ps1 -Help
```

If PowerShell blocks script execution, see the [Quick Start FAQ](docs/QUICK_START.en.md#what-if-powershell-blocks-the-scripts).

## Output Files

- `content-diagnosis.md`: asset-readiness diagnosis with score, verdict, gaps, rewrite actions, and recommended image count. With `-Semantic`, it also includes the LLM semantic review.
- `analysis.md`: title, paragraph count, language signal, and cognitive anchors.
- `illustration-shot-list.md`: theme, structure, character action, and suggested elements for each image.
- `image-prompts.md`: full prompts you can copy into an image generation tool.
- `image-prompts.jsonl`: structured jobs for CLI or batch workflows.
- `distribution-plan.md`: how Chinese and English audiences can consume the same project experience differently.
- `publish-checklist.md`: checks that prevent plans, mocks, or placeholders from being presented as finished work.

## Axin IP Assets

![Axin bilingual workflow main visual](axin-personal-ip-illustrations/assets/examples/01-axin-human-bilingual-workflow.png)

![Axin IP asset board](axin-personal-ip-illustrations/assets/examples/06-axin-ip-asset-board.png)

![Axin human character anchor](axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png)

## Workflow Examples

![Axin project QA desk](axin-personal-ip-illustrations/assets/examples/03-axin-human-repo-review-desk.png)

![Axin agent discovery flow](axin-personal-ip-illustrations/assets/examples/04-axin-human-geo-agent-discovery.png)

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

## Install As An Agent Skill

Run the sample workflow first, then install when you actually want agent integration:

```powershell
.\scripts\install-local-skill.ps1
```

Sync the plugin snapshot:

```powershell
.\scripts\sync-platform-packages.ps1
```

See [docs/MULTI_PLATFORM.md](docs/MULTI_PLATFORM.md) for the protected platform guide.

## Generation Rules

- Default canvas: 16:9 horizontal article image. Character anchors may be 1:1.
- Pure white background, no paper texture, beige tint, shadow, or gradient.
- Black hand-drawn line art, sparse orange for paths, red for warnings/results, blue for system feedback.
- One image explains one judgement, workflow, state, or metaphor.
- Labels should be short. Use Chinese, English, or very sparse bilingual labels depending on the publishing context.
- Axin or the custom IP must participate in the core action. If the image still works after removing the character, the image fails.

## Validation

```powershell
.\scripts\validate-repo.ps1
```

The validator checks required files, example images, skill metadata, platform snapshots, bilingual README entries, quick-start docs, diagnosis scripts, and the sample article.

## License

MIT License. See [LICENSE](LICENSE).
