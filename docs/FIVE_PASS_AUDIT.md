# Five-Pass Usability Audit

Date: 2026-06-24

This audit checks whether the repository is actually usable by an open-source user, not just locally presentable.

## Pass 1: First-Run User Path

Goal: verify that a user can reach the project from GitHub and run the documented first-run workflow.

Checks:

- GitHub raw files for `README.md`, `docs/QUICK_START.md`, `scripts/analyze-article.ps1`, `scripts/lib/ContentDiagnosis.ps1`, `scripts/new-content-package.ps1`, and `examples/sample-article.md` returned HTTP 200.
- A no-`.git` local copy, equivalent to a ZIP extraction, successfully ran:

```powershell
.\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md
.\scripts\new-content-package.ps1 -ArticlePath .\examples\sample-article.md -Slug first-run-audit -ImageCount 4 -LanguageMode zh
```

Result:

- `content-diagnosis.md`, `image-prompts.md`, and `metadata.json` were generated.
- The scripts do not require a Git checkout.

Observed risk:

- On this machine, full `git clone` and GitHub codeload ZIP download stalled during audit. Raw GitHub access worked. The Quick Start now includes PowerShell and slow download troubleshooting.

## Pass 2: Diagnosis Quality

Goal: check whether `analyze-article.ps1` gives useful verdicts instead of blindly approving every input.

Cases:

- Sample article: `ready`, high score.
- Weak English slogan: `not_ready`, `RecommendedImageCount = 0`.
- Empty Chinese slogan: `not_ready`, `RecommendedImageCount = 0`.
- Short evidence/workflow note: initially failed too harshly; fixed to `diagnose_before_prompts`.
- Technical English workflow note: `diagnose_before_prompts`, with 1-2 images recommended.

Fix:

- `scripts/lib/ContentDiagnosis.ps1` now lets short but evidence-backed workflow notes reach a low-score diagnosis state instead of hard rejection.

Remaining limitation:

- This is a heuristic diagnosis layer, not a semantic LLM reviewer. It is useful as a gate and checklist, but users should still read the article and diagnosis manually.

## Pass 3: Windows And Path Robustness

Goal: catch real PowerShell and Windows path failures.

Checks:

- Article path with spaces.
- Absolute `-OutRoot` path with spaces.
- `-ImageCount 99` clamps to `8`.
- `-ImageCount 0` clamps to `1`.
- Missing article text fails clearly.
- Missing `-CharacterImagePath` target fails clearly.
- `-OutFile` writes a diagnosis report under a folder path with spaces.

Bug found:

- Short inputs could make PowerShell treat anchors/templates as scalar objects, causing `Attempted to divide by zero` when generating scenes.

Fix:

- `new-content-package.ps1` now wraps anchors and templates with `@(...)` before indexing.

## Pass 4: Public Documentation And LLM Entrypoints

Goal: verify that external users and agents discover the right workflow.

Checks:

- README and README.en mention diagnosis before prompt generation.
- `docs/QUICK_START.md` and `docs/QUICK_START.en.md` list `content-diagnosis.md`.
- `docs/index.html` now explains `content-diagnosis.md` before `image-prompts.md`.
- `llms.txt` and `llms-full.txt` expose `scripts/analyze-article.ps1`.
- Quick Start includes PowerShell execution policy and browser ZIP unblock guidance.

Fix:

- Added troubleshooting for `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` and `Unblock-File`.
- Added slow clone/download fallback guidance.

## Pass 5: Repository Hygiene And Release State

Goal: verify the public repo state and local repository quality.

Checks:

- `.\scripts\validate-repo.ps1`: passed.
- `git diff --check`: no whitespace errors.
- Secret scan: no real secrets found; only `OPENAI_API_KEY` environment variable checks.
- Legacy/bad-translation scan: clean outside intentional audit/validator references.
- `content-packages/` contains only `.gitkeep`.
- GitHub API reports repository is public, default branch is `main`.

Remote metadata observed:

- Repository: `paidaxing1234/axin-personal-ip-illustrations`
- Public: true
- Default branch: `main`
- Topics observed: `ai-workflow`, `chinese-content`, `codex-skill`, `illustrations`, `imagegen`, `personal-ip`

Suggested future improvement:

- Add topics such as `llms-txt`, `content-workflow`, `article-to-image`, `personal-brand`, and `agent-skill`.

## Verdict

The repository is usable for the core open-source workflow:

```powershell
.\scripts\analyze-article.ps1 -ArticlePath .\examples\sample-article.md
.\scripts\new-content-package.ps1 -ArticlePath .\examples\sample-article.md -Slug sample-article -ImageCount 4 -LanguageMode zh
```

It now does more than generate prompts: it first diagnoses whether the article deserves to become a visual IP asset.

The main remaining limitation is that the diagnosis is heuristic. For deeper judgement, the next step should be an optional LLM-backed reviewer that writes `content-diagnosis.md` with quoted article evidence and stronger editorial reasoning.
