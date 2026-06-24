# 多平台支持

## 平台矩阵

| 平台 | 入口文件 | 安装方式 | 状态 |
| --- | --- | --- | --- |
| `Codex` | `axin-personal-ip-illustrations/SKILL.md` | `scripts/install-local-skill.ps1` | 已支持 |
| `Hermes` | 同一份 `SKILL.md` | `scripts/install-hermes-skill.ps1` | 已支持 |
| `Claude Code` | `CLAUDE.md` / `.claude-plugin/` | 作为 repo 上下文或插件包 | 已支持 |
| `Cursor` | `.cursor/rules/axin-personal-ip-illustrations.mdc` | 自动读取 rules | 已支持 |
| `Windsurf` | `.windsurfrules` | 自动读取 rules | 已支持 |
| `Cline` | `.clinerules/axin-personal-ip-illustrations.md` | 自动读取 rules | 已支持 |
| `OpenCode` / 通用 agents | `AGENTS.md` / `llms.txt` | 读取仓库说明 | 已支持 |

说明：平台产品名一律保留英文原名，不做中文音译或意译。

## `Codex`

```powershell
.\scripts\install-local-skill.ps1
```

安装位置：

```text
C:\Users\<you>\.codex\skills\axin-personal-ip-illustrations
```

## `Hermes`

```powershell
.\scripts\install-hermes-skill.ps1
```

安装位置：

```text
$HERMES_HOME\skills\creative\axin-personal-ip-illustrations
```

使用：

```bash
hermes -s axin-personal-ip-illustrations
```

## `Claude Code`

`Claude Code` 可以直接读取：

- `CLAUDE.md`
- `.claude-plugin/plugin.json`
- `.claude-plugin/commands/axin-illustrate.md`

插件目录里保留一个 skill snapshot，方便迁移到 Claude Code plugin 工作流。

## 通用 Agent

给任何 agent 的最小提示：

```text
Read llms.txt first. Then read axin-personal-ip-illustrations/SKILL.md.
Use the prompt template and QA checklist. Save generated images under assets/<topic-slug>-illustrations/.
```
