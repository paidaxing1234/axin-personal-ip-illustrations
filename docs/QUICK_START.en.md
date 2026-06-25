# Quick Start

This guide is for open-source users who are opening the repository for the first time. The recommended path is conversational: reference the skill in an agent chat and paste your article. If the agent has image generation, it should generate the images. If not, it should return complete prompts. The CLI is an optional batch and file-output path.

## What You Get

In conversation mode, you get:

- Recommended image count.
- Where each image belongs in the article.
- What each image expresses.
- Generated images when an image tool is available.
- Complete prompts when no image tool is available.

In CLI mode, the script reads a Markdown or TXT article and creates a content package:

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

The repository does not try to hide everything behind a magic button. It diagnoses whether the article is ready to become assets, then produces reviewable, generatable, reusable illustration plans.

## 1. Use It In Conversation

In an agent that supports skills, type:

```text
Use $axin-personal-ip-illustrations
Here is my article. First decide how many illustrations it deserves.
If you have image generation, generate the images directly.
If not, return complete prompts for each image.

<paste article>
```

If you have your own IP character image, attach it with the article:

```text
Use $axin-personal-ip-illustrations
Use my attached IP character as the reference instead of default Axin.
Analyze the article and create 4 article illustrations.
If image generation is available, generate them. Otherwise return prompts.

<paste article>
```

## 2. Optional CLI Sample

If you want a saved content package or batch workflow, run this from the repository root:

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

You can also print the script help:

```powershell
.\scripts\new-content-package.ps1 -Help
```

Diagnose only, without generating prompts:

```powershell
.\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md
```

Optional: use LLM semantic review for stricter judgement:

```powershell
$env:OPENAI_API_KEY = "<your key>"
.\scripts\analyze-article.ps1 `
  -ArticlePath .\examples\sample-article.md `
  -Semantic
```

## 3. Use Your Own Article With CLI

Save your article as Markdown or TXT, then run:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -ImageCount 5 `
  -LanguageMode auto
```

If you do not pass `-Slug`, the script derives the output folder from the article title.

If you want `content-diagnosis.md` to include the LLM semantic review, add `-Semantic`:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -ImageCount 5 `
  -LanguageMode auto `
  -Semantic
```

## 4. Use Your Own IP Character With CLI

If you already have a personal IP character image, avatar, concept image, or visual reference, pass it as the character anchor:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -CharacterImagePath .\path\to\your-ip.png `
  -CharacterName "Your IP" `
  -ImageCount 5 `
  -LanguageMode en
```

The script copies the character reference into `character-reference/` and tells every image prompt to preserve the same identity, hairstyle, face shape, clothing, attitude, and line-art style.

## 5. Read The CLI Output

- `content-diagnosis.md`: asset-readiness diagnosis with score, verdict, gaps, rewrite actions, and recommended image count. With `-Semantic`, it also includes the LLM semantic review.
- `analysis.md`: title, paragraphs, language signal, and cognitive anchors.
- `illustration-shot-list.md`: what each image should express, what objects appear, and what the character does.
- `image-prompts.md`: full prompts you can copy into an image generation tool.
- `image-prompts.jsonl`: structured jobs for CLI or batch generation.
- `distribution-plan.md`: how Chinese and English audiences can consume the same project experience differently.
- `publish-checklist.md`: checks before publishing, especially around evidence and finished-vs-placeholder claims.

## 6. Generate Images

In conversation mode, an image-capable agent should generate images directly. In CLI mode, this repository creates reviewable illustration prompts first. Copy each prompt from `image-prompts.md` into your image generation tool, or let an image-capable agent read `image-prompts.jsonl` and generate one image per job.

Check each image before using it:

- The character should perform the core action, not stand as decoration.
- The image should keep a pure white background, black hand-drawn line art, and enough blank space.
- Text should stay sparse.
- The image should express one judgement, workflow, evidence point, or pitfall from the article.

## FAQ

### What If PowerShell Blocks The Scripts?

If Windows blocks script execution, allow scripts for the current terminal process:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

If you downloaded the repository as a ZIP from the browser, files may be marked as downloaded from the internet. From the repository root, run:

```powershell
Get-ChildItem -Recurse -File | Unblock-File
```

### What If Git Clone Or Download ZIP Is Slow?

First check whether raw files are reachable, then download the minimum files if you only want to test the scripts. The minimum set is `scripts/`, `examples/sample-article.md`, and `axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png`. Full usage still works best with the whole repository because README, docs, skill rules, and visual examples evolve together.

### Do I Have To Use Axin?

No. Axin is the default character so the workflow works immediately. In conversation mode, attach your IP character image and tell the agent to use it as the reference. In CLI mode, pass `-CharacterImagePath` and `-CharacterName` to use your own IP character.

### Does The Script Generate PNG Files?

It depends on where you use it. In conversation mode, if the agent has image generation, it should generate PNG files directly. The CLI script itself does not generate PNG files; `new-content-package.ps1` creates article diagnosis, analysis, and prompt packages.

### Is The English Output Just Translation?

No. Chinese publishing often focuses on process, retrospectives, mistakes, and judgement. English publishing often focuses on the repository, workflow, reusability, and LLM discoverability. `distribution-plan.md` separates these contexts instead of doing literal translation.

### What If The Prompts Feel Generic?

Improve the article input first. The script extracts anchors from the article. If the article only has slogans and no evidence, tradeoffs, workflow, or concrete actions, the prompts will feel empty too.

### What Do The Diagnosis Verdicts Mean?

- `ready`: move into shot lists and image prompts.
- `usable_with_edits`: prompts are usable, but revise the article before publishing.
- `diagnose_before_prompts`: improve the article before generating many images.
- `not_ready`: do not generate images yet; add judgement, evidence, workflow, and audience.

### How Is Semantic Review Different From The Default Diagnosis?

The default diagnosis is an offline heuristic check. It does not need an API key and is useful for quickly checking judgement, evidence, workflow, reader value, and visual anchors. `-Semantic` calls the OpenAI Responses API and returns structured JSON that checks whether the article is slogan-only, whether it mixes finished work with plans, and whether it deserves illustration prompts.

### What If Semantic Review Says `OPENAI_API_KEY is not set`?

You enabled `-Semantic`, but the current environment does not have an OpenAI API key. Remove `-Semantic` to use offline diagnosis, or set the key in the current PowerShell session:

```powershell
$env:OPENAI_API_KEY = "<your key>"
```

### How Do I Install It As A Skill?

After the sample workflow works:

```powershell
.\scripts\install-local-skill.ps1
```

See `docs/MULTI_PLATFORM.md` for more agent entrypoints.
