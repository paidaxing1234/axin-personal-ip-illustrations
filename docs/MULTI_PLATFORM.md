# 多平台支持

> 本页的平台产品名必须保留英文原名。为避免浏览器自动翻译改写产品名，平台名区域使用 `translate="no"` 和 `notranslate` 标记。

## 平台矩阵

<table translate="no" class="notranslate">
  <thead>
    <tr>
      <th>Platform</th>
      <th>Entry</th>
      <th>Install / Load</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code translate="no">Codex</code></td>
      <td><code translate="no">axin-personal-ip-illustrations/SKILL.md</code></td>
      <td><code translate="no">scripts/install-local-skill.ps1</code></td>
      <td>supported</td>
    </tr>
    <tr>
      <td><code translate="no">Hermes</code></td>
      <td><code translate="no">SKILL.md</code></td>
      <td><code translate="no">scripts/install-hermes-skill.ps1</code></td>
      <td>supported</td>
    </tr>
    <tr>
      <td><code translate="no">Claude Code</code></td>
      <td><code translate="no">CLAUDE.md</code> / <code translate="no">.claude-plugin/</code></td>
      <td>repo context or plugin package</td>
      <td>supported</td>
    </tr>
    <tr>
      <td><code translate="no">Cursor</code></td>
      <td><code translate="no">.cursor/rules/axin-personal-ip-illustrations.mdc</code></td>
      <td>rules auto-load</td>
      <td>supported</td>
    </tr>
    <tr>
      <td><code translate="no">Windsurf</code></td>
      <td><code translate="no">.windsurfrules</code></td>
      <td>rules auto-load</td>
      <td>supported</td>
    </tr>
    <tr>
      <td><code translate="no">Cline</code></td>
      <td><code translate="no">.clinerules/axin-personal-ip-illustrations.md</code></td>
      <td>rules auto-load</td>
      <td>supported</td>
    </tr>
    <tr>
      <td><code translate="no">OpenCode</code> / generic agents</td>
      <td><code translate="no">AGENTS.md</code> / <code translate="no">llms.txt</code></td>
      <td>read repository guide</td>
      <td>supported</td>
    </tr>
  </tbody>
</table>

## 安装：<code translate="no">Codex</code>

```powershell
.\scripts\install-local-skill.ps1
```

安装位置：

```text
C:\Users\<you>\.codex\skills\axin-personal-ip-illustrations
```

## 安装：<code translate="no">Hermes</code>

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

或在 <code translate="no">Hermes</code> 会话中：

```text
/reload-skills
```

## 使用：<code translate="no">Claude Code</code>

<code translate="no">Claude Code</code> 可以直接读取：

- `CLAUDE.md`
- `.claude-plugin/plugin.json`
- `.claude-plugin/commands/axin-illustrate.md`

插件目录里保留一个 skill snapshot，方便迁移到 plugin 工作流。

## 通用 Agent

给任何 agent 的最小提示：

```text
Read llms.txt first. Then read axin-personal-ip-illustrations/SKILL.md.
Use the prompt template and QA checklist. Save generated images under assets/<topic-slug>-illustrations/.
```
