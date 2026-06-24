# Agent Instructions

This repository is a multi-platform personal IP illustration workflow.

## Core Task

Use `axin-personal-ip-illustrations/SKILL.md` as the source of truth. The skill turns Chinese personal-brand content, public-build notes, project retrospectives, GitHub README material, and AI workflow writing into hand-drawn 16:9 article illustrations.

## Required Workflow

1. Read the user content or topic.
2. Extract cognitive anchors: judgement, workflow, contrast, evidence, reuse, publishing path, or common pitfall.
3. Produce a short shot list before generating more than one image.
4. Use 阿鑫 / Axin as the default and only recurring character.
5. Generate one image per concept. Do not collage multiple illustrations into one canvas.
6. Save workspace-bound final assets under `assets/<topic-slug>-illustrations/`.
7. Run `scripts/validate-repo.ps1` before committing repository changes.

## Style Guardrails

- Pure white background.
- Minimal black hand-drawn line art.
- Lots of white space.
- Sparse red, orange, and blue handwritten Chinese notes.
- No PPT look, no commercial vector poster, no dense explainer page.
- The character must perform the core action.

## Platform Files

- Codex: `axin-personal-ip-illustrations/SKILL.md`
- Hermes: `scripts/install-hermes-skill.ps1`
- Claude Code: `CLAUDE.md` and `.claude-plugin/`
- Generic agents: `llms.txt`, `llms-full.txt`, `docs/MULTI_PLATFORM.md`
