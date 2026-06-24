# Prompt Examples

下面这些 prompt 可以直接复制到 agent 里使用。第一次使用建议先跑脚本示例，不要一上来就安装 skill。

## CLI：三分钟跑通

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\examples\sample-article.md `
  -Slug sample-article `
  -ImageCount 4 `
  -LanguageMode zh
```

生成后打开：

```text
content-packages/sample-article/image-prompts.md
```

完整说明见 `docs/QUICK_START.md`。

## 只做配图规划

```text
Use $axin-personal-ip-illustrations 先不要生图。
请分析下面这篇文章哪里值得配图，输出 5 张左右的 shot list。
每张图写清楚：
- 放在哪个段落后
- 图的主题
- 核心意思
- 结构类型
- 阿鑫在图里做什么
- 建议元素
- 建议中文标注词

<粘贴文章>
```

## 文章正文配图

```text
Use $axin-personal-ip-illustrations 把下面这篇文章生成 4 张阿鑫个人 IP 正文配图。
要求：16:9 横版、纯白背景、黑色手绘线稿、少量红橙蓝中文手写批注。
每张图只讲一个核心结构。阿鑫保持黑发、眼镜、hoodie 的真人手绘形象，不要做 PPT 信息图，不要可爱卡通。

<粘贴文章>
```

## CLI：文章转配图提示词包

```powershell
.\scripts\new-content-package.ps1 `
  -ArticlePath .\articles\my-post.md `
  -CharacterImagePath .\assets\my-ip.png `
  -CharacterName "你的IP名" `
  -ImageCount 5 `
  -LanguageMode zh
```

输出重点：

- `analysis.md`：文章标题、段落、认知锚点。
- `illustration-shot-list.md`：每张图的主题、结构和角色动作。
- `image-prompts.md`：可复制到生图工具的逐张 prompt。
- `image-prompts.jsonl`：适合 CLI 批量生图的结构化任务。
- `distribution-plan.md`：中文和英文平台各自怎么消费同一篇文章。

## 单个观点生成一张图

```text
Use $axin-personal-ip-illustrations 为这个观点生成一张 16:9 正文配图：

真实状态比漂亮包装更重要。

画面要怪诞但清爽。阿鑫保持黑发、眼镜、hoodie 的真人手绘形象，必须承担核心动作，可以在发布闸门前给未验证内容贴红色警示标签。
中文标注最多 5 个，短一点。
```

## GitHub README 配图

```text
Use $axin-personal-ip-illustrations 为一个 GitHub 开源项目 README 生成一张头图。
主题：从本地脚本到可复用工具包。
不要商业 KV，不要科技感 UI。让阿鑫把散乱脚本接线整理成一个可复用工具包。
```

## 内容复利主题

```text
Use $axin-personal-ip-illustrations 为“一个真实项目可以复用成文章、视频、README、案例库”生成一张图。
不要画标准飞轮，不要画平台 logo。重新发明一个低科技隐喻，让阿鑫参与核心动作。
```

## 改图：去掉标题

```text
Use $axin-personal-ip-illustrations 帮我编辑这张图。
去掉左上角的“Workflow / 流程图”标题和下划线，其他内容保持不变。
不要新增任何文字或物件。
```

## 改图：增强阿鑫参与感

```text
Use $axin-personal-ip-illustrations 这张图方向对，但阿鑫有点像装饰。
请保持核心意思不变，重生成一版：让阿鑫成为真正推动结构运转的人。
画面更怪一点，但仍然纯白、清爽、少字。
阿鑫必须保持黑发、眼镜、hoodie 的真人手绘形象。
```
