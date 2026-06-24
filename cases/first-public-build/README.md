# 案例：真人阿鑫重建

## 背景

这次仓库最真实的问题不是“少一张图”，而是视觉主线跑偏：阿鑫被做成了非人类工具角色，和用户给出的真人手绘参考图不一致。用户连续反馈“丑”，最后明确指出应该使用一张真人阿鑫接线分流图作为方向。

## 原始问题

- 示例图和 prompt 把阿鑫引向非人类工具角色。
- README、SKILL、llms、Claude 插件快照和 prompt 文件存在旧方向残留。
- CLI 批量生成没有强制参考图，容易再次漂移。
- 校验脚本只检查图片存在和尺寸，不能防止旧人设回潮。

## 关键判断

阿鑫应该是“真人手绘内容操作员”，不是吉祥物。识别点必须固定：

- 黑发。
- 圆框眼镜。
- hoodie。
- 白底黑色手绘线稿。
- 少量橙色线缆、红色警示、蓝色 agent 信号。
- 动作必须参与真实项目到内容资产的转换。

## 已产出

- 主视觉：`axin-personal-ip-illustrations/assets/examples/01-axin-human-bilingual-workflow.png`
- 角色锚点：`axin-personal-ip-illustrations/assets/examples/02-axin-human-character-anchor.png`
- 仓库自审图：`axin-personal-ip-illustrations/assets/examples/03-axin-human-repo-review-desk.png`
- agent 可发现图：`axin-personal-ip-illustrations/assets/examples/04-axin-human-geo-agent-discovery.png`
- 内容复用图：`axin-personal-ip-illustrations/assets/examples/05-axin-human-content-reuse-workbench.png`

## 流程改造

- 删除旧非人类示例图和旧 prompt。
- 用 CLI 基于真人阿鑫参考图生成补充资产。
- 更新 README、README.en、SKILL、prompt template、QA、llms、平台规则。
- 将 Codex 和 Hermes 本地 skill 安装为新版本。
- 在 validator 中加入旧方向残留检查。

## 验证命令

```powershell
.\scripts\validate-repo.ps1
.\scripts\install-local-skill.ps1
.\scripts\install-hermes-skill.ps1
```

## 可复用经验

- 被用户明确否定的视觉方向，不应该继续留在主 prompt 或示例资产里。
- 图片仓库要把图片当测试样本，而不是装饰。
- 多平台 skill 必须同步快照，否则旧设定会从另一个入口复活。
- CLI 生成应该绑定参考图，尤其是角色 IP 资产。
