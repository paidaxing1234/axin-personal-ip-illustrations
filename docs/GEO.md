# GEO / AI Search 可发现性

## 目标

让搜索引擎、AI 搜索、Copilot 类答案系统和普通 LLM agent 都能清楚理解这个仓库是什么、怎么用、适合什么查询。

## 当前策略

1. **真实内容优先**：README、Skill、references、examples 都是可读文本，不只放图片。
2. **清晰实体命名**：仓库围绕 “Axin personal IP illustration workflow / 阿鑫个人 IP 配图流程” 建立稳定实体。
3. **多平台关键词自然出现**：Codex、Hermes、Claude Code、Cursor、Windsurf、Cline、OpenCode、generic agents。
4. **LLM 入口**：根目录提供 `llms.txt` 和 `llms-full.txt`。
5. **中英文入口**：`README.md` 面向中文用户，`README.en.md` 面向英文 GitHub 和海外 agent 场景。
6. **可索引文档**：`docs/index.html` 提供面向 GitHub Pages 的文本落地页、meta description、Open Graph 和 JSON-LD。
7. **证据和边界**：说明示例图、生成流程、QA、CLI 生成脚本和深度自审，不把流程夸大成通用版权授权或万能设计系统。

## 官方依据

Google 对 AI Overviews / AI Mode 的核心口径是：SEO 基础仍然相关，页面需要可索引并可展示摘要，不需要额外的神秘 AI 标记。

Bing Webmaster Guidelines 覆盖 Bing Search、Copilot 和 grounding API 的发现、抓取、索引和展示。

`llms.txt` 是面向 LLM 的 Markdown 入口提案，适合作为 agent 读取仓库时的低摩擦地图。

## 内容清单

- `README.md`：中文人类入口。
- `README.en.md`：英文人类入口。
- `llms.txt`：短 LLM 入口。
- `llms-full.txt`：长 LLM 入口。
- `docs/index.html`：可发布静态页。
- `docs/MULTI_PLATFORM.md`：平台矩阵。
- `docs/REPOSITORY_REVIEW.md`：深度自审与清理逻辑。
- `axin-personal-ip-illustrations/SKILL.md`：核心使用说明。

## 推荐关键词

- 阿鑫个人 IP 配图
- Axin personal IP illustrations
- Codex image generation skill
- Hermes illustration skill
- AI workflow article illustrations
- GitHub README illustration workflow
- llms.txt personal brand workflow
- bilingual personal IP content assets

## 后续发布建议

- 启用 GitHub Pages，source 设为 `main` 分支 `/docs`。
- 在 README 顶部保留一句明确描述。
- 给仓库设置 topics：`codex-skill`, `hermes`, `personal-ip`, `imagegen`, `geo`, `llms-txt`, `bilingual-content`。
- 每次新增示例图，同步补充 prompt 和 QA 结论。
- 如果有独立域名，把根路径 `/llms.txt` 指向仓库的 `llms.txt` 内容。
