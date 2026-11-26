/**
 * Styleophm 设计 token（两级制）。
 *
 * 1. 基础刻度：颜色 / 间距 / 圆角 / 字号 / 行高，全部是不可变标量；
 * 2. StylexColor：资源化颜色（`$r('app.color.*')`），随系统深浅色自动切换。
 *
 * 为什么同时保留两套颜色：
 * - `StylexToken.INK` 这类十六进制字符串用于必须拿原始色值的场景（Canvas、导出、日志、快照对比）；
 * - 界面上的颜色请用 `StylexColor.INK`，否则深色模式不会跟随。
 */

export class StylexToken {
  // ---------------------------------------------------------------------------
  // 颜色（浅色基准值，与 resources/base/element/color.json 一一对应）
  // ---------------------------------------------------------------------------
  static readonly INK: string = '#1B2438';
  static readonly INK_SOFT: string = '#6B7794';
  static readonly INK_FAINT: string = '#8A93A8';
  static readonly BRAND: string = '#17345C';
  static readonly BRAND_DEEP: string = '#102642';
  static readonly BRAND_SOFT: string = '#E9EEF8';
  static readonly GOLD: string = '#C9A227';
  static readonly GOLD_SOFT: string = '#FAF2DA';
  static readonly SURFACE: string = '#FFFFFF';
  static readonly SURFACE_SOFT: string = '#F8FAFD';
  static readonly CANVAS: string = '#F3F5FA';
  static readonly LINE: string = '#E2E7F2';
  static readonly NEUTRAL_SOFT: string = '#F1F3F8';
  static readonly DANGER: string = '#C0392B';
  static readonly DANGER_SOFT: string = '#FBEDEB';
  static readonly SUCCESS: string = '#1F8A5B';
  static readonly VIOLET: string = '#6C4BD8';
  static readonly VIOLET_SOFT: string = '#EFEBFC';
  static readonly GREEN_SOFT: string = '#E6F4EC';
  static readonly AMBER: string = '#B07A12';
  static readonly AMBER_SOFT: string = '#FBF1DD';
  static readonly SLATE: string = '#41508C';
  static readonly SLATE_SOFT: string = '#E9ECF8';

  /** 深色底上的前景色：始终明亮，不参与深浅色切换 */
  static readonly ON_DARK: string = '#FFFFFF';
  static readonly ON_DARK_SOFT: string = '#C9D6EC';
  static readonly ON_DARK_GOLD: string = '#F0D98A';
  static readonly ON_DARK_BRAND: string = '#2A4A72';

  // ---------------------------------------------------------------------------
  // 间距（4dp 网格）
  // ---------------------------------------------------------------------------
  static readonly SPACE_2XS: number = 2;
  static readonly SPACE_XS: number = 4;
  static readonly SPACE_SM: number = 8;
  static readonly SPACE_MD: number = 12;
  static readonly SPACE_LG: number = 16;
  static readonly SPACE_XL: number = 24;
  static readonly SPACE_2XL: number = 32;

  // ---------------------------------------------------------------------------
  // 圆角
  // ---------------------------------------------------------------------------
  static readonly RADIUS_XS: number = 9;
  static readonly RADIUS_SM: number = 10;
  static readonly RADIUS_MD: number = 14;
  static readonly RADIUS_LG: number = 16;
  static readonly RADIUS_XL: number = 20;
  static readonly RADIUS_2XL: number = 24;
  /** 胶囊：大于任何高度的一半，效果等价于 高度 / 2 */
  static readonly RADIUS_PILL: number = 999;

  // ---------------------------------------------------------------------------
  // 字号
  // ---------------------------------------------------------------------------
  static readonly FONT_CAPTION: number = 11;
  static readonly FONT_LABEL: number = 12;
  static readonly FONT_BODY: number = 14;
  static readonly FONT_BODY_LG: number = 15;
  static readonly FONT_TITLE: number = 17;
  static readonly FONT_DISPLAY: number = 24;

  // ---------------------------------------------------------------------------
  // 行高（与字号成对使用）
  // ---------------------------------------------------------------------------
  static readonly LINE_CAPTION: number = 16;
  static readonly LINE_LABEL: number = 18;
  static readonly LINE_SOFT: number = 21;
  static readonly LINE_BODY: number = 22;
  static readonly LINE_TITLE: number = 24;
  static readonly LINE_LOOSE: number = 26;
  static readonly LINE_HERO: number = 27;
  static readonly LINE_DISPLAY: number = 32;
  /** @deprecated 等于 LINE_LABEL，保留以兼容旧代码 */
  static readonly LINE_TIGHT: number = 18;
}

/**
 * 资源化颜色 token：取值来自 `resources/{base,dark}/element/color.json`，
 * 深浅色随系统自动切换。所有 Spec 的颜色字段都接受这些 ResourceColor。
 */
export class StylexColor {
  static readonly INK: ResourceColor = $r('app.color.ink');
  static readonly INK_SOFT: ResourceColor = $r('app.color.ink_soft');
  static readonly INK_FAINT: ResourceColor = $r('app.color.ink_faint');
  static readonly BRAND: ResourceColor = $r('app.color.brand');
  static readonly BRAND_DEEP: ResourceColor = $r('app.color.brand_deep');
  static readonly BRAND_SOFT: ResourceColor = $r('app.color.brand_soft');
  static readonly GOLD: ResourceColor = $r('app.color.gold');
  static readonly GOLD_SOFT: ResourceColor = $r('app.color.gold_soft');
  static readonly SURFACE: ResourceColor = $r('app.color.surface');
  static readonly SURFACE_SOFT: ResourceColor = $r('app.color.surface_soft');
  static readonly CANVAS: ResourceColor = $r('app.color.canvas');
  static readonly LINE: ResourceColor = $r('app.color.line');
  static readonly NEUTRAL_SOFT: ResourceColor = $r('app.color.neutral_soft');
  static readonly DANGER: ResourceColor = $r('app.color.danger');
  static readonly DANGER_SOFT: ResourceColor = $r('app.color.danger_soft');
  static readonly SUCCESS: ResourceColor = $r('app.color.success');
  static readonly VIOLET: ResourceColor = $r('app.color.violet');
  static readonly VIOLET_SOFT: ResourceColor = $r('app.color.violet_soft');
  static readonly GREEN_SOFT: ResourceColor = $r('app.color.green_soft');
  static readonly AMBER: ResourceColor = $r('app.color.amber');
  static readonly AMBER_SOFT: ResourceColor = $r('app.color.amber_soft');
  static readonly SLATE: ResourceColor = $r('app.color.slate');
  static readonly SLATE_SOFT: ResourceColor = $r('app.color.slate_soft');

  static readonly ON_DARK: ResourceColor = $r('app.color.on_dark');
  static readonly ON_DARK_SOFT: ResourceColor = $r('app.color.on_dark_soft');
  static readonly ON_DARK_GOLD: ResourceColor = $r('app.color.on_dark_gold');
  static readonly ON_DARK_BRAND: ResourceColor = $r('app.color.on_dark_brand');
}
