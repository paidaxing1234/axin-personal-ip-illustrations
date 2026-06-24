# 通用 Agent 平台

如果平台不支持 Codex/Hermes/Claude 的专用 skill 格式，让 agent 按顺序读取：

1. `llms.txt`
2. `axin-personal-ip-illustrations/SKILL.md`
3. `axin-personal-ip-illustrations/references/prompt-template.md`
4. `axin-personal-ip-illustrations/references/qa-checklist.md`

最小提示：

```text
Read llms.txt and use this repository as a personal IP illustration workflow. Produce a shot list first, then generate one image per concept, and save final images under assets/<topic-slug>-illustrations/.
```

