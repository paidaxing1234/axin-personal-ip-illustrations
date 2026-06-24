# Quick Start

This guide is for open-source users who are opening the repository for the first time. You do not need to install the agent skill first, and you do not need your own IP character image yet. Run the sample article once, then replace it with your own article.

## What You Get

The script reads a Markdown or TXT article and creates a content package:

```text
content-packages/<slug>/
├── article.md
├── analysis.md
├── illustration-shot-list.md
├── image-prompts.md
├── image-prompts.jsonl
├── distribution-plan.md
├── readme-snippet.md
├── publish-checklist.md
└── images/
```

The repository does not try to hide everything behind a magic button. It produces reviewable prompts, shot lists, and publishing notes before you spend image generation credits.

## 1. Run The Sample

From the repository root:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\examples\sample-article.md `
  -Slug sample-article `
  -ImageCount 4 `
  -LanguageMode en
```

Then open:

```text
content-packages/sample-article/image-prompts.md
```

You can also print the script help:

```powershell
.\scripts\new-content-package.ps1 -Help
```

## 2. Use Your Own Article

Save your article as Markdown or TXT, then run:

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\path\to\your-article.md `
  -ImageCount 5 `
  -LanguageMode auto
```

If you do not pass `-Slug`, the script derives the output folder from the article title.

## 3. Use Your Own IP Character

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

## 4. Read The Output

- `analysis.md`: title, paragraphs, language signal, and cognitive anchors.
- `illustration-shot-list.md`: what each image should express, what objects appear, and what the character does.
- `image-prompts.md`: full prompts you can copy into an image generation tool.
- `image-prompts.jsonl`: structured jobs for CLI or batch generation.
- `distribution-plan.md`: how Chinese and English audiences can consume the same project experience differently.
- `publish-checklist.md`: checks before publishing, especially around evidence and finished-vs-placeholder claims.

## 5. Generate Images

This repository creates reviewable illustration prompts first. Copy each prompt from `image-prompts.md` into your image generation tool, or let an image-capable agent read `image-prompts.jsonl` and generate one image per job.

Check each image before using it:

- The character should perform the core action, not stand as decoration.
- The image should keep a pure white background, black hand-drawn line art, and enough blank space.
- Text should stay sparse.
- The image should express one judgement, workflow, evidence point, or pitfall from the article.

## FAQ

### Do I Have To Use Axin?

No. Axin is the default character so the workflow works immediately. Pass `-CharacterImagePath` and `-CharacterName` to use your own IP character.

### Does The Script Generate PNG Files?

No. `new-content-package.ps1` creates article analysis and prompt packages. Use your own image generation tool after reviewing the shot list and prompts.

### Is The English Output Just Translation?

No. Chinese publishing often focuses on process, retrospectives, mistakes, and judgement. English publishing often focuses on the repository, workflow, reusability, and LLM discoverability. `distribution-plan.md` separates these contexts instead of doing literal translation.

### What If The Prompts Feel Generic?

Improve the article input first. The script extracts anchors from the article. If the article only has slogans and no evidence, tradeoffs, workflow, or concrete actions, the prompts will feel empty too.

### How Do I Install It As A Skill?

After the sample workflow works:

```powershell
.\scripts\install-local-skill.ps1
```

See `docs/MULTI_PLATFORM.md` for more agent entrypoints.
