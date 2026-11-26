# Styleophm 变更记录

格式参照 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - 2026-11-27

首个可用版本：核心修饰器 + 两级 token + 深浅色 + 示例工程。

### Added

- `StylexBox` / `StylexRow` 新增 `alignItems`、`justifyContent`、`layoutWeight`、`flexGrow`、`flexShrink`、`clip`；
- 新增四角独立圆角（`radiusTopLeft` 等）与四边独立边框宽度（`borderTopWidth` 等）；
- `StylexButton` 新增按压态：`applyPressedAttribute` + `pressedBackground` / `pressedOpacity`（默认 0.82），`stateEffect` 可控；
- `StylexText` 合并原 `StylexTag` 能力：`background` / `paddingH` / `paddingV` / `radius` / `decoration` / `fontFamily` / `overflow`；
- `StylexText.maxLines` 现在自动配套 `TextOverflow.Ellipsis`，可用 `ellipsis: false` 或 `overflow` 覆盖；
- 新增资源化颜色 `StylexColor`（`$r('app.color.*')`）与 `resources/base|dark/element/color.json`，深浅色自动跟随；
- 新增 `PactLayer` / `PactStage` 枚举，`PactTag.forLayer/forStage`、`PactAccent.*` 改为枚举入参（仍兼容字符串）；
- 新增 `entry` 示例模块（视觉回归页），覆盖排版、标签、按钮、容器能力、自定义修饰器；
- 新增 `scripts/guard.mjs` 静态守卫与 `.github/workflows/ci.yml`；
- 新增 `LICENSE`（MIT）与 `CHANGELOG.md`；`oh-package.json5` 补齐 `license` / `keywords` / `homepage` / `repository`；`entry` 依赖本库 `file:../styleophm`。

### Changed

- 所有 `Spec` 的颜色字段从 `string` 放宽为 `ResourceColor`，十六进制字符串与 `StylexColor.*` 都能直接传；
- `StylexTag` 改为继承 `StylexText`，删除重复的属性写入实现（约 48 行），`StylexTagSpec` 变为 `StylexTextSpec` 的别名；
- 预设层（`PactStyles.ets`）零裸值：所有数值收敛到 `PactMetric`，所有颜色收敛到 `StylexColor`；
- 构造 `Spec` 时做显式浅拷贝，外部对象后续修改不再影响已创建的样式；
- 圆角刻度重排为 `RADIUS_XS 9 / SM 10 / MD 14 / LG 16 / XL 20 / 2XL 24 / PILL 999`；
- 行高刻度补齐 `LINE_CAPTION 16 / LABEL 18 / SOFT 21 / BODY 22 / TITLE 24 / LOOSE 26 / HERO 27 / DISPLAY 32`；
- 示例应用 `bundleName` 改为 `com.styleophm.showcase`，`vendor` 改为 `styleophm`。

### Fixed

- 只传 `borderWidth` 未传 `borderColor` 时，边框会画成默认黑色 —— 现在缺省补 `StylexToken.LINE`；
- `StylexButton` 此前没有任何按下反馈；
- `maxLines` 此前是硬裁切，没有省略号；
- `PactTag.forLayer('政策层')` 这类裸字符串比较拼错时静默落到 `NEUTRAL`，现在有枚举约束。

### Visual deltas（预设归一化到 4dp 网格，肉眼几乎无感）

- `PactBox.HERO` 内边距 18 → 16；
- `PactBox.SOFT` 内边距 14 → 12；
- 按钮圆角由固定值（23 / 20 / 17）统一为 `RADIUS_PILL`，效果与“高度一半”一致。

### Notes

- 编译目标：`compatibleSdkVersion 6.1.1(24)`、`targetSdkVersion 26.0.1`、`modelVersion 26.0.1`；
- HAR 产物：`styleophm/build/default/outputs/default/styleophm.har`。
