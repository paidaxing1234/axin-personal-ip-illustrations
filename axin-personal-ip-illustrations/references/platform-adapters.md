# 多平台适配

## 目标

同一套个人 IP 配图流程应能被 Codex、Hermes、Claude Code、Cursor、Windsurf、Cline、OpenCode 和通用 agent 平台读取。

核心原则：

- `axin-personal-ip-illustrations/SKILL.md` 是主源。
- `references/` 是跨平台知识库。
- `examples/prompts.md` 是人工和 agent 都能复制的入口。
- `llms.txt` 和 `llms-full.txt` 是 GEO/LLM 可发现入口。

## Codex

安装：

```powershell
.\scripts\install-local-skill.ps1
```

使用：

```text
Use $axin-personal-ip-illustrations 为这篇内容生成 4 张正文配图。
```

## Hermes

安装：

```powershell
.\scripts\install-hermes-skill.ps1
```

使用：

```bash
hermes -s axin-personal-ip-illustrations
```

或在会话里：

```text
/skill axin-personal-ip-illustrations
```

Hermes skill 推荐放在：

```text
$HERMES_HOME/skills/creative/axin-personal-ip-illustrations/SKILL.md
```

## Claude Code

仓库提供：

- `CLAUDE.md`
- `.claude-plugin/`
- `.claude-plugin/commands/axin-illustrate.md`

Claude Code 可以直接读取仓库上下文，也可以把 `.claude-plugin` 打包成插件。

## Cursor / Windsurf / Cline / OpenCode

仓库提供：

- `.cursor/rules/axin-personal-ip-illustrations.mdc`
- `.windsurfrules`
- `.clinerules/axin-personal-ip-illustrations.md`
- `AGENTS.md`

这些平台至少能读取同一套角色、风格、QA 和输出路径规范。

## 通用 Agent

最小输入：

```text
Read llms.txt first, then read axin-personal-ip-illustrations/SKILL.md and references/prompt-template.md.
Generate a shot list before generating images. Save final images under assets/<topic-slug>-illustrations/.
```

