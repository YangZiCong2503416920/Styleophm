# Styleophm

**StyleX 思路的 HarmonyOS ArkUI 样式库**：用「命名 token + 类型化 `AttributeModifier`」替代动态样式对象，写法接近 StyleX，但完全符合 ArkTS 严格模式（无索引签名、无 `any`、无动态属性访问）。

```ts
import { PactBox, PactText, StylexToken } from 'styleophm';

Text('五年规划')
  .attributeModifier(PactText.HERO)

Column() { /* ... */ }
  .attributeModifier(PactBox.CARD)
```

---

## 为什么不用 stylex.create？

Web 版 StyleX 依赖动态键访问与结构化对象，在 ArkTS 中会触发：

- `arkts-no-props-by-index`（`style[color]` 这类索引访问）
- `arkts-no-untyped-obj-literals`（匿名样式对象）
- `arkts-no-obj-literals-as-types`

本库的解法：

1. `StylexToken` 集中管理颜色、间距、圆角、字号、行高；
2. `StylexText / StylexBox / StylexTag / StylexButton / StylexRow` 是对应 ArkUI 组件的 `AttributeModifier` 实现，构造时传入**有类型的 Spec**；
3. 预设样式（`PactText` / `PactBox` / `PactTag` / `PactButton` / `PactAccent`）以静态只读实例暴露，组件里一行 `.attributeModifier(...)` 即可复用。

这样样式只创建一次、可跨组件复用，并且能被 ArkTS 编译器完整类型检查。

---

## 安装

### 方式一：本地路径依赖（开发期）

在使用方工程根目录 `oh-package.json5`：

```json5
{
  "dependencies": {
    "styleophm": "file:../Styleophm/styleophm"
  }
}
```

然后同步依赖：

```bash
ohpm install
```

### 方式二：HAR 产物

```bash
devecocli build     # 或 DevEco Studio Build > Make Module 'styleophm'
```

产物位于 `styleophm/build/default/outputs/default/styleophm.har`，可直接放入 `libs/` 引用。

---

## 目录

```text
styleophm/
├─ Index.ets                    统一导出（使用方从这里 import）
├─ oh-package.json5
├─ build-profile.json5
├─ hvigorfile.ts
└─ src/main/
   ├─ module.json5              type: har
   └─ ets/
      ├─ Stylex.ets             核心 AttributeModifier 实现 + Spec 类型
      ├─ StylexTokens.ets       设计 token（颜色/间距/圆角/字号/行高）
      └─ PactStyles.ets         预设样式示例（PactText/PactBox/PactTag/PactButton/PactAccent）
```

---

## API

### 核心修饰器

| 类 | 作用组件 | Spec |
| --- | --- | --- |
| `StylexText` | `Text` | `StylexTextSpec`（size / weight / color / lineHeight / maxLines / align / letterSpacing） |
| `StylexBox` | `Column` | `StylexBoxSpec`（尺寸 / 四向 padding·margin / 背景 / 圆角 / 边框 / 透明度） |
| `StylexTag` | `Text` | `StylexTagSpec`（字号 / 字重 / 前后景 / 横纵 padding / 圆角） |
| `StylexButton` | `Button` | `StylexButtonSpec`（高度 / 字号 / 字重 / 前景 / 背景 / 圆角） |
| `StylexRow` | `Row` | `StylexRowSpec`（尺寸 / padding / margin / 背景 / 圆角 / 底边框） |

### Token

`StylexToken` 提供：

- 颜色：`INK` `INK_SOFT` `INK_FAINT` `BRAND` `BRAND_DEEP` `BRAND_SOFT` `GOLD` `GOLD_SOFT` `SURFACE` `CANVAS` `LINE` `DANGER` `SUCCESS` `VIOLET` `VIOLET_SOFT` `GREEN_SOFT` `AMBER` `AMBER_SOFT` `SLATE` `SLATE_SOFT`
- 间距：`SPACE_XS/SM/MD/LG/XL`
- 圆角：`RADIUS_SM/MD/LG`
- 字号：`FONT_CAPTION/LABEL/BODY/BODY_LG/TITLE/DISPLAY`
- 行高：`LINE_TIGHT/BODY/LOOSE`

### 预设

```ts
import { PactAccent, PactBox, PactButton, PactTag, PactText } from 'styleophm';

Text('标题').attributeModifier(PactText.TITLE)
Column() { /* ... */ }.attributeModifier(PactBox.CARD)
Button('保存').attributeModifier(PactButton.PRIMARY)
Text('政策层').attributeModifier(PactTag.forLayer('政策层'))
Text('近期').fontColor(PactAccent.forStage('近期'))
```

> `PactXxx` 预设来自一个真实项目（五年之约）的视觉体系，作为「如何组织 token 与预设」的参考实现。实际项目可以按同样方式编写自己的 `AppText` / `AppBox`。

---

## 自定义样式

```ts
import { StylexBox, StylexText, StylexToken } from 'styleophm';

const NoticeBox: StylexBox = new StylexBox({
  background: StylexToken.GOLD_SOFT,
  radius: StylexToken.RADIUS_SM,
  paddingTop: 10,
  paddingRight: 12,
  paddingBottom: 10,
  paddingLeft: 12
});

const NoticeText: StylexText = new StylexText({
  size: StylexToken.FONT_BODY,
  color: StylexToken.AMBER,
  lineHeight: StylexToken.LINE_BODY
});
```

---

## 环境

- HarmonyOS NEXT / API 12+
- ArkTS 严格模式
- 模块类型：HAR

## 说明

本仓库只包含样式层，不依赖任何业务代码或网络能力。`PactStyles.ets` 是预设示例，可按项目需要增删。
