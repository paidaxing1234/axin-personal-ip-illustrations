# Claude Code 平台

Claude Code 可以直接读取：

- `CLAUDE.md`
- `.claude-plugin/plugin.json`
- `.claude-plugin/commands/axin-illustrate.md`
- `.claude-plugin/skills/axin-personal-ip-illustrations/SKILL.md`

插件目录中的 skill 是根目录主 skill 的快照。更新主 skill 后，运行：

```powershell
.\scripts\sync-platform-packages.ps1
```

