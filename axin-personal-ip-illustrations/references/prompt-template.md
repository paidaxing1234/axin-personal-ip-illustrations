# 生图提示词模板

每张图单独生成。根据正文内容替换变量，不要把多张图拼在一起。

```text
Use case: illustration-story
Asset type: personal IP article illustration
Primary request: Generate one standalone 16:9 horizontal article illustration for the Axin personal IP workflow.

Visual DNA:
Pure white background. Minimalist black hand-drawn line art. Slightly wobbly pen lines. Lots of empty white space. Sparse red/orange/blue handwritten annotations. Clean absurd content-workbench sketch feeling. No gradients, no shadows, no paper texture, no complex background, no commercial vector style, no PPT infographic look, no cute mascot poster, no children's illustration, no realistic UI.

Recurring IP character required:
阿鑫 / Axin, a hand-drawn human content operator with messy black hair, round glasses, and a light hoodie. Keep the face simple, quiet, focused, slightly deadpan, and not cute. 阿鑫 must perform the core conceptual action, not decorate the scene. Preserve the human identity: black hair, glasses, hoodie, clean sketch lines, practical posture.

Theme:
{正文配图主题}

Structure type:
{内容工坊 / 证据质检 / 前后对比 / 资产分层 / 发布路径 / 复利飞轮 / 角色状态 / 小漫画分镜}

Core idea:
{这张图要表达的核心意思}

Composition:
{具体画面：阿鑫在哪里、正在做什么、主要物件是什么、信息如何流动}

Suggested elements:
{元素1} / {元素2} / {元素3} / {元素4}

Handwritten labels:
{标注词1} / {标注词2} / {标注词3} / {标注词4} / {可选标注词5}

Language mode:
{Chinese labels / English labels / very sparse bilingual labels}

Color use:
Black for main line art, hair, objects, and labels. Orange for main flow/path/cables/arrows. Red only for key warnings, unverified items, problems, or results. Blue only for secondary notes, AI assistance, or system state.

Constraints:
One image explains only one core structure. Keep the main subject around 40%-60% of the canvas. Preserve at least 35% blank white space. Use at most 5-8 short handwritten labels. Do not write a title in the top-left corner. Do not write the structure type on the image. Keep Axin as a human content operator, not a generic mascot, robot, prop, logo, anime character, or abstract icon. Do not make it a formal diagram, course slide, or dense explainer. Do not copy prior examples or reuse known case compositions unless explicitly requested; invent a fresh visual metaphor for this specific content. It should be clear but not instructional, interesting but not childish, strange but clean. No watermark, no logo, no extra characters.
```

## 9:16 竖屏图文卡片模板

用于抖音图文、小红书图文、竖屏轮播和短内容卡片。每张卡片单独调用 `image_gen`，不要把多张图拼在一张里。

```text
Use case: illustration-story
Asset type: 9:16 vertical short-form carousel card
Primary request: Generate one standalone 9:16 vertical carousel card for the Axin personal IP workflow.

Visual DNA:
Pure white background. Minimalist black hand-drawn line art. Slightly wobbly pen lines. Lots of empty white space. Sparse red/orange/blue handwritten annotations. Clean absurd content-workbench sketch feeling. No gradients, no shadows, no paper texture, no complex background, no commercial poster style, no PPT infographic look, no cute mascot poster.

Recurring IP character required:
阿鑫 / Axin, a hand-drawn human content operator with messy black hair, round glasses, and a light hoodie. 阿鑫 must perform the core conceptual action, not decorate the corner. Preserve the human identity: black hair, glasses, hoodie, clean sketch lines, practical posture.

Card role:
{封面 / 痛点 / 流程 / 判断 / 分支 / 复用 / 行动}

Core idea:
{这一页只表达一个核心意思}

Composition:
{竖屏构图：上方留标题区，中部是阿鑫动作和主物件，下方留短标注或行动提示}

Suggested visual elements:
{元素1} / {元素2} / {元素3} / {元素4}

Optional short text:
{最多 6-14 个中文字；如果不确定文字准确性，就留空白标题区，不要生成长段中文}

Color use:
Black for main line art, hair, objects, and labels. Orange for main flow/path/cables/arrows. Red only for warnings or problems. Blue only for AI assistance or system state.

Constraints:
9:16 vertical composition. One card explains only one idea. Keep at least 35% blank white space for platform text overlay. Do not create a dense poster. Do not make a collage. Do not include logos, QR codes, watermarks, fake UI, tiny unreadable text, or long paragraphs. Keep Axin as a human content operator, not a generic mascot, robot, prop, logo, anime character, or abstract icon.
```

## 图像编辑提示

去掉左上角标题：

```text
Edit the provided image. Remove only the handwritten title "{要删除的文字}" and its underline from the top-left corner. Fill that area with the same clean white background, matching the surrounding blank area. Preserve everything else exactly: character, labels, paths, line style, composition, aspect ratio, and image quality. Do not add any new text or objects.
```

增强阿鑫参与感：

```text
Regenerate this illustration with the same core meaning and simple layout, but make 阿鑫 / Axin more central to the conceptual action. 阿鑫 should be doing the strange work that explains the idea, not standing beside the diagram. Keep it clean, sparse, hand-drawn, deadpan, and not cute.
```

减少文字：

```text
Regenerate the same concept with fewer handwritten labels. Keep only 3-4 very short labels. Preserve the white background, hand-drawn line style, 阿鑫 as the action subject, and the same core meaning.
```
