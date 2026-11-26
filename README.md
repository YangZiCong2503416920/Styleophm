# Styleophm

ArkTS 严格模式下，你写不出 `style[color]`、也传不了匿名样式对象，于是每个页面都在重复同一串 `.fontSize(14).fontColor('#17345C').lineHeight(22)`，还在 12 个文件里散着 85 个十六进制色值——改一次视觉规范就得全库搜索替换，深色模式更是无处下手。

Styleophm 把这些重复收成 **命名 token + 类型化 `AttributeModifier` 预设**：一行挂上去，顺手拿到深色模式。

```ts
import { PactText, PactBox, PactButton } from 'styleophm';

Text('五年规划').attributeModifier(PactText.HERO)
Column() { /* ... */ }.attributeModifier(PactBox.CARD)
Button('保存').attributeModifier(PactButton.PRIMARY)
```

- 许可证：MIT · 模块类型：HAR · `compatibleSdkVersion 6.1.1(24)` / `targetSdkVersion 26.0.1`
- 33 个资源化颜色 token，`base` + `dark` 两套，随系统深浅色自动切换
- 真机验证：nova 14 Pro（HarmonyOS 7.0.0 / API 26），示例工程与真实项目 PactFive 均已跑通

---

## 为什么 `@Styles` / `@Extend` 不够

ArkUI 自带的两种复用手段都有硬限制：

| | `@Styles` | `@Extend(Text)` | Styleophm |
|---|---|---|---|
| 跨文件复用 | 需到处 import 静态方法 | **不行**，仅当前文件作用域 | 行 |
| 带参数 | **不行**（不支持入参） | 可以，但只能包一层 | 行（构造 Spec） |
| 一次定义多处挂载 | 每次调用重新生成 | 每次调用重新生成 | 静态实例，构建一次全 App 复用 |
| 绑设计 token / 深色资源 | **不行**，只能写死色值 | **不行** | 行（`StylexColor`） |
| 类型安全 | 弱（隐式 any 风险） | 弱 | 强（Spec 接口 + ArkTS 严格模式） |
| 按钮按下态 | 不支持声明式复用 | 不支持 | 行（`applyPressedAttribute`） |

30 行对比——同一个卡片头，写三遍之后你就不想再写第四遍：

```ts
// 迁移前：每个页面各写一遍，色值是字符串，深色模式下全是死色
Text('排版刻度')
  .fontSize(17).fontWeight(FontWeight.Bold)
  .fontColor('#1B2438').lineHeight(24)

Row() {
  Text('五年之约').fontSize(34).fontColor('#FFFFFF')
}
.padding({ left: 16, right: 16, top: 16, bottom: 16 })
.backgroundColor('#17345C')
.borderRadius(20)
```

```ts
// 迁移后：样式只创建一次，颜色是资源，深色自动跟随
Text('排版刻度').attributeModifier(PactText.TITLE)

Row() {
  Text('五年之约').attributeModifier(PactText.HERO).fontColor(StylexColor.ON_BRAND)
}
.attributeModifier(PactBox.HERO)
```

---

## 真实项目数据（PactFive，39 个 .ets）

| 指标 | 迁移前 | 迁移后 |
|---|---|---|
| 硬编码色值 `'#RRGGBB'` | **85 处 / 12 个文件** | **4 处**（全是系统栏 `'#00000000'`，API 只收字符串） |
| 取色方式 | 各页面字符串 + 10 个 `PactTheme` 常量 | 79 处 `StylexColor.*`，`PactTheme` 变成一行别名 |
| 深色模式 | 无 | 跟随系统，全页翻转 |
| 改一次品牌色 | 全库搜索替换 | 改 `color.json` 一处 |

真机前后对比（左＝浅色，右＝深色，同一份代码）：

<a href="docs/pactfive-light.jpg"><img src="docs/pactfive-light.jpg" width="300" alt="PactFive 浅色"></a>
<a href="docs/pactfive-dark.jpg"><img src="docs/pactfive-dark.jpg" width="300" alt="PactFive 深色"></a>

迁移过程中踩到一个坑，值得写进任何 HAR 作者的手册：**自己 HAP 里定义资源，别用 `brand` / `ink` 这类通用名**。宿主的 `app.color.brand` 与系统 `sys.color.brand` 撞名时，运行时会拿到系统的亮蓝（#0A59F7），而不是你的深蓝——所以本库所有资源都带 `stylex_` 前缀。

## 预览（示例工程 `entry`）

<a href="docs/preview-top.jpg"><img src="docs/preview-top.jpg" width="300" alt="Styleophm 预览 · 上半屏"></a>
<a href="docs/preview-bottom.jpg"><img src="docs/preview-bottom.jpg" width="300" alt="Styleophm 预览 · 下半屏"></a>

---

## 安装

### 方式一：本地路径依赖（开发期）

使用方**模块**的 `oh-package.json5`：

```json5
{
  "dependencies": {
    "styleophm": "file:../Styleophm/styleophm"
  }
}
```

```bash
ohpm install
```

### 方式二：HAR 产物（交付）

```json5
{
  "dependencies": {
    "styleophm": "file:./libs/styleophm.har"
  }
}
```

`devecocli build --modules styleophm@default` 产出 `styleophm/build/default/outputs/default/styleophm.har`。

> hvigor 不允许模块路径逃出工程根，所以跨仓库时模块级 `srcPath` 指向外部目录会报 `Path escapes project root`。两个仓库各自独立时，用「HAR + 一键同步」最省事：`pwsh scripts/sync-styleophm.ps1`（见 PactFive 仓库的 `scripts/`）。

---

## 目录

```text
Styleophm/
├─ styleophm/                       HAR 模块（对外发布的部分）
│  ├─ Index.ets                     统一导出（19 个公共符号）
│  ├─ oh-package.json5              license / keywords / repository
│  └─ src/main/
│     ├─ module.json5               type: har
│     ├─ ets/
│     │  ├─ Stylex.ets              5 个 AttributeModifier + Spec 类型
│     │  ├─ StylexTokens.ets        StylexToken（标量）+ StylexColor（资源）
│     │  └─ PactStyles.ets          预设（PactText/Box/Tag/Button/Accent）
│     └─ resources/{base,dark}/element/color.json   33 个 token / 两套值
├─ entry/                           示例 App（HAP），视觉回归页
├─ scripts/guard.mjs                静态守卫：token 纪律 / 调色板 / 导出 / 严格模式 / 版本
├─ .github/workflows/ci.yml         CI：guard 必跑，hvigor 构建按需
├─ docs/                            真机截图
└─ CHANGELOG.md / LICENSE(MIT)
```

---

## API

### 核心修饰器

| 类 | 作用组件 | Spec 主要字段 |
| --- | --- | --- |
| `StylexText` | `Text` | `size` `weight` `color` `lineHeight` `maxLines` `align` `letterSpacing` `ellipsis` `overflow` `fontFamily` `decoration` `background` `paddingH` `paddingV` `radius` |
| `StylexTag` | `Text` | 同 `StylexText`（继承实现，`StylexTagSpec` 是其别名） |
| `StylexBox` | `Column` | `width` `height` 四向 `padding`·`margin` `background` `radius`（含四角独立） 四边 `border*Width` `borderColor` `opacity` `alignItems` `justifyContent` `layoutWeight` `flexGrow` `flexShrink` `clip` |
| `StylexRow` | `Row` | 同 `StylexBox`，`alignItems` 类型为 `VerticalAlign` |
| `StylexButton` | `Button` | `width` `height` `size` `weight` `color` `background` `radius` `stateEffect` `pressedBackground` `pressedOpacity` |

要点：

- **颜色字段统一是 `ResourceColor`**：既接受 `StylexColor.INK`（跟随深浅色），也接受 `'#1B2438'`；
- **边框颜色默认补 `StylexToken.LINE`**：只写 `borderWidth` 不会得到黑边；
- **`maxLines` 自动配省略号**：默认 `TextOverflow.Ellipsis`，要硬裁切就 `ellipsis: false` 或 `overflow: TextOverflow.Clip`；
- **按钮有按压态**：`applyPressedAttribute`，默认透明度 0.82，可用 `pressedBackground` 换成更深的品牌色。

> **覆盖顺序**：`attributeModifier` 的属性优先级高于链式调用。想改预设的某个属性（例如把卡片内容居中），请在 Spec 里给（或另建一个 `StylexBox`），别指望在 `.attributeModifier(...)` 之后再追一个同名方法——会被预设覆盖回去。

### Token（两级制）

第一级 · 标量 `StylexToken`：

| 组 | 取值 |
| --- | --- |
| 颜色（hex） | `INK` `INK_SOFT` `INK_FAINT` `BRAND` `BRAND_LIGHT` `BRAND_DEEP` `BRAND_SOFT` `GOLD` `GOLD_DEEP` `GOLD_SOFT` `SURFACE` `SURFACE_SOFT` `CANVAS` `LINE` `NEUTRAL_SOFT` `DANGER` `DANGER_SOFT` `SUCCESS` `VIOLET` `VIOLET_SOFT` `GREEN_SOFT` `AMBER` `AMBER_SOFT` `SLATE` `SLATE_SOFT` `ON_DARK` `ON_DARK_SOFT` `ON_DARK_MUTED` `ON_DARK_FAINT` `ON_DARK_GOLD` `ON_DARK_DANGER` `ON_DARK_BRAND` `ON_BRAND` |
| 间距 | `SPACE_2XS 2` `SPACE_XS 4` `SPACE_SM 8` `SPACE_MD 12` `SPACE_LG 16` `SPACE_XL 24` `SPACE_2XL 32` |
| 圆角 | `RADIUS_XS 9` `RADIUS_SM 10` `RADIUS_MD 14` `RADIUS_LG 16` `RADIUS_XL 20` `RADIUS_2XL 24` `RADIUS_PILL 999` |
| 字号 | `FONT_CAPTION 11` `FONT_LABEL 12` `FONT_BODY 14` `FONT_BODY_LG 15` `FONT_TITLE 17` `FONT_DISPLAY 24` |
| 行高 | `LINE_CAPTION 16` `LINE_LABEL 18` `LINE_SOFT 21` `LINE_BODY 22` `LINE_TITLE 24` `LINE_LOOSE 26` `LINE_HERO 27` `LINE_DISPLAY 32` |

第二级 · 资源化颜色 `StylexColor`：33 个键，对应 `resources/{base,dark}/element/color.json`（资源名统一 `stylex_` 前缀，避免与宿主/系统资源撞名）。

```ts
import { StylexColor } from 'styleophm';

Column().backgroundColor(StylexColor.SURFACE)   // 深色模式自动变 #151C28
```

`ON_DARK_*` 是「深色底上的前景色」：`ON_DARK` / `ON_DARK_SOFT` / `ON_DARK_MUTED` / `ON_DARK_FAINT` 四级，加上 `ON_DARK_GOLD`、`ON_DARK_DANGER`、`ON_DARK_BRAND`。而 `ON_BRAND` 是「品牌底色上的字」：浅色主题白字，深色主题（品牌色变亮为 `#8FB4E8`）自动切成近黑字，避免白字贴浅蓝底。

### 预设与枚举

```ts
import { PactAccent, PactBox, PactButton, PactLayer, PactStage, PactTag, PactText } from 'styleophm';

Text('标题').attributeModifier(PactText.TITLE)
Column() { /* ... */ }.attributeModifier(PactBox.CARD)
Button('保存').attributeModifier(PactButton.PRIMARY)
Text('政策层').attributeModifier(PactTag.forLayer(PactLayer.POLICY))
Text('近期').fontColor(PactAccent.forStage(PactStage.NEAR))
```

- `PactLayer`：`POLICY`（政策层）/ `INDUSTRY`（行业层）/ `PERSONAL`（个人层）
- `PactStage`：`NEAR`（近期）/ `MID`（中期）/ `FAR`（远期）
- 首选用枚举：拼错是编译错误，不再是静默落到 `NEUTRAL`；传字符串仍然兼容。

> `PactXxx` 预设来自真实项目「五年之约」的视觉体系，既是开箱即用的样式，也是「如何组织 token 与预设」的参考实现。实际项目可以按同样方式写自己的 `AppText` / `AppBox`。

---

## 自定义样式

```ts
import { StylexBox, StylexText, StylexColor, StylexToken } from 'styleophm';

const NoticeBox: StylexBox = new StylexBox({
  background: StylexColor.GOLD_SOFT,
  radius: StylexToken.RADIUS_MD,
  paddingTop: StylexToken.SPACE_MD,
  paddingRight: StylexToken.SPACE_MD,
  paddingBottom: StylexToken.SPACE_MD,
  paddingLeft: StylexToken.SPACE_MD,
  borderWidth: 1,
  borderColor: StylexColor.GOLD,
  alignItems: HorizontalAlign.Start
});

const NoticeText: StylexText = new StylexText({
  size: StylexToken.FONT_BODY,
  color: StylexColor.AMBER,
  lineHeight: StylexToken.LINE_BODY,
  maxLines: 2
});
```

新增配置项时请同时更新 `copyXxxSpec`（`Stylex.ets` 底部）——`scripts/guard.mjs` 不检查这一点，但漏了会变成「字段写了不生效」。

---

## 示例工程

`entry` 是可直接运行的 HAP（`bundleName: com.styleophm.showcase`），覆盖排版刻度、标签/阶段、按钮按压态、容器对齐能力、自定义修饰器：

```bash
cd entry && ohpm install    # 首次
cd .. && devecocli build    # 产出 entry HAP + styleophm.har
devecocli run               # 真机/模拟器视觉回归
```

真机安装需要签名材料：登录 `devecocli auth login` 后 `devecocli signature generate` 自动生成；或复用已有的 debug 证书（注意 profile 绑定 bundleName，需要临时改 `AppScope/app.json5`）。

---

## 开发与校验

```bash
node scripts/guard.mjs          # 静态守卫（零依赖，CI 必跑）
devecocli build                 # ArkTS 编译 + 打包
devecocli check lint            # DevEco Code Linter
```

`scripts/guard.mjs` 会拦住：调色板深浅色键不一致、`$r('app.color.*')` 指向不存在的资源、预设层出现裸色值/裸数值、公共符号没从 `Index.ets` 导出、`any` / `@ts-ignore` / `eslint-disable`、四处版本号不一致。

---

## 环境

- HarmonyOS NEXT，`compatibleSdkVersion 6.1.1(24)`、`targetSdkVersion 26.0.1`、`modelVersion 26.0.1`
- ArkTS 严格模式（`arkts-no-*` 全套规则不得关闭）
- 模块类型：HAR；示例工程：HAP
- 工具：DevEco Studio / `devecocli`（自带 hvigor + ohpm）

## 发布到 ohpm

ohpm 就是鸿蒙侧的 npm。物料与报错对照见 [docs/publishing.md](docs/publishing.md)，配好 publish_id 后一条命令：

```powershell
$env:OHPM_PUBLISH_ID = '<你的 publish_id>'
pwsh scripts/publish.ps1
```

之后使用方就能 `ohpm install styleophm`。

## 版本

- 变更记录见 [CHANGELOG.md](CHANGELOG.md)
- 许可证：[MIT](LICENSE)
