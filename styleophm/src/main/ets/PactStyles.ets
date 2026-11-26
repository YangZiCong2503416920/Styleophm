import { StylexBox, StylexButton, StylexTag, StylexText } from './Stylex';
import { StylexColor, StylexToken } from './StylexTokens';

/**
 * 预设层（PactXxx）。
 *
 * 约束：本文件不允许出现裸数值/裸色值 —— 所有度量先落到 `PactMetric`，
 * 所有颜色先落到 `StylexColor`（资源化，跟随深浅色）。
 * 业务侧只需要 `.attributeModifier(PactText.TITLE)`，不需要知道任何具体数值。
 */

/** 语义枚举：替代裸中文字符串比较，拼错会在编译期报错 */
export enum PactLayer {
  POLICY = '政策层',
  INDUSTRY = '行业层',
  PERSONAL = '个人层'
}

export enum PactStage {
  NEAR = '近期',
  MID = '中期',
  FAR = '远期'
}

/**
 * 组件级度量（design token 的第二级）。
 * 这里是整个库里唯一允许出现“网格外微调”的地方，改样式只改这里。
 */
class PactMetric {
  /** 胶囊标签横向内边距：比 SPACE_MD 紧一档 */
  static readonly CHIP_PADDING_H: number = 10;
  /** 胶囊标签纵向内边距 */
  static readonly CHIP_PADDING_V: number = 3;
  /** 按钮高度 */
  static readonly BUTTON_HEIGHT_PRIMARY: number = 46;
  static readonly BUTTON_HEIGHT_GHOST: number = 40;
  static readonly BUTTON_HEIGHT_SMALL: number = 34;
  /** 发丝边框 */
  static readonly HAIRLINE: number = 1;
}

export class PactText {
  static readonly DISPLAY: StylexText = new StylexText({
    size: StylexToken.FONT_DISPLAY,
    weight: FontWeight.Bold,
    color: StylexColor.INK,
    lineHeight: StylexToken.LINE_DISPLAY
  });

  static readonly HERO: StylexText = new StylexText({
    size: StylexToken.FONT_TITLE,
    weight: FontWeight.Bold,
    color: StylexColor.INK,
    lineHeight: StylexToken.LINE_HERO
  });

  static readonly HERO_ON_DARK: StylexText = new StylexText({
    size: StylexToken.FONT_TITLE,
    weight: FontWeight.Bold,
    color: StylexColor.ON_DARK,
    lineHeight: StylexToken.LINE_HERO
  });

  static readonly TITLE: StylexText = new StylexText({
    size: StylexToken.FONT_TITLE,
    weight: FontWeight.Bold,
    color: StylexColor.INK,
    lineHeight: StylexToken.LINE_TITLE
  });

  static readonly SUBTITLE: StylexText = new StylexText({
    size: StylexToken.FONT_LABEL,
    color: StylexColor.INK_SOFT,
    lineHeight: StylexToken.LINE_LABEL
  });

  static readonly BODY: StylexText = new StylexText({
    size: StylexToken.FONT_BODY,
    color: StylexColor.INK,
    lineHeight: StylexToken.LINE_BODY
  });

  static readonly BODY_SOFT: StylexText = new StylexText({
    size: StylexToken.FONT_BODY,
    color: StylexColor.INK_SOFT,
    lineHeight: StylexToken.LINE_SOFT
  });

  static readonly ACTION: StylexText = new StylexText({
    size: StylexToken.FONT_BODY,
    color: StylexColor.INK,
    lineHeight: StylexToken.LINE_SOFT
  });

  static readonly QUOTE: StylexText = new StylexText({
    size: StylexToken.FONT_BODY_LG,
    color: StylexColor.INK,
    lineHeight: StylexToken.LINE_LOOSE
  });

  static readonly LABEL: StylexText = new StylexText({
    size: StylexToken.FONT_LABEL,
    color: StylexColor.INK_SOFT,
    lineHeight: StylexToken.LINE_LABEL
  });

  static readonly CAPTION: StylexText = new StylexText({
    size: StylexToken.FONT_CAPTION,
    color: StylexColor.INK_FAINT,
    lineHeight: StylexToken.LINE_CAPTION
  });

  static readonly CAPTION_ON_DARK: StylexText = new StylexText({
    size: StylexToken.FONT_CAPTION,
    color: StylexColor.ON_DARK_SOFT,
    lineHeight: StylexToken.LINE_CAPTION
  });

  static readonly TOGGLE: StylexText = new StylexText({
    size: StylexToken.FONT_LABEL,
    weight: FontWeight.Medium,
    color: StylexColor.BRAND,
    lineHeight: StylexToken.LINE_LABEL
  });
}

export class PactBox {
  static readonly CARD: StylexBox = new StylexBox({
    background: StylexColor.SURFACE,
    radius: StylexToken.RADIUS_LG,
    paddingTop: StylexToken.SPACE_LG,
    paddingRight: StylexToken.SPACE_LG,
    paddingBottom: StylexToken.SPACE_LG,
    paddingLeft: StylexToken.SPACE_LG
  });

  static readonly HERO: StylexBox = new StylexBox({
    background: StylexColor.BRAND,
    radius: StylexToken.RADIUS_XL,
    paddingTop: StylexToken.SPACE_LG,
    paddingRight: StylexToken.SPACE_LG,
    paddingBottom: StylexToken.SPACE_LG,
    paddingLeft: StylexToken.SPACE_LG
  });

  static readonly SOFT: StylexBox = new StylexBox({
    background: StylexColor.BRAND_SOFT,
    radius: StylexToken.RADIUS_MD,
    paddingTop: StylexToken.SPACE_MD,
    paddingRight: StylexToken.SPACE_MD,
    paddingBottom: StylexToken.SPACE_MD,
    paddingLeft: StylexToken.SPACE_MD
  });

  static readonly QUOTE: StylexBox = new StylexBox({
    background: StylexColor.SURFACE_SOFT,
    radius: StylexToken.RADIUS_MD,
    paddingTop: StylexToken.SPACE_LG,
    paddingRight: StylexToken.SPACE_LG,
    paddingBottom: StylexToken.SPACE_LG,
    paddingLeft: StylexToken.SPACE_LG,
    borderWidth: PactMetric.HAIRLINE,
    borderColor: StylexColor.LINE
  });
}

export class PactTag {
  private static readonly POLICY: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.BRAND,
    background: StylexColor.BRAND_SOFT,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  private static readonly INDUSTRY: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.VIOLET,
    background: StylexColor.VIOLET_SOFT,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  private static readonly PERSONAL: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.AMBER,
    background: StylexColor.GOLD_SOFT,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  private static readonly STAGE_NEAR: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.SUCCESS,
    background: StylexColor.GREEN_SOFT,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  private static readonly STAGE_MID: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.AMBER,
    background: StylexColor.AMBER_SOFT,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  private static readonly STAGE_FAR: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.SLATE,
    background: StylexColor.SLATE_SOFT,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  private static readonly NEUTRAL: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.INK_SOFT,
    background: StylexColor.NEUTRAL_SOFT,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  static readonly ON_DARK: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexColor.ON_DARK_GOLD,
    background: StylexColor.ON_DARK_BRAND,
    paddingH: PactMetric.CHIP_PADDING_H,
    paddingV: PactMetric.CHIP_PADDING_V,
    radius: StylexToken.RADIUS_XS
  });

  static forLayer(layer: PactLayer | string): StylexTag {
    if (layer === PactLayer.POLICY) {
      return PactTag.POLICY;
    }
    if (layer === PactLayer.INDUSTRY) {
      return PactTag.INDUSTRY;
    }
    if (layer === PactLayer.PERSONAL) {
      return PactTag.PERSONAL;
    }
    return PactTag.NEUTRAL;
  }

  static forStage(stage: PactStage | string): StylexTag {
    if (stage === PactStage.NEAR) {
      return PactTag.STAGE_NEAR;
    }
    if (stage === PactStage.MID) {
      return PactTag.STAGE_MID;
    }
    if (stage === PactStage.FAR) {
      return PactTag.STAGE_FAR;
    }
    return PactTag.NEUTRAL;
  }
}

export class PactButton {
  static readonly PRIMARY: StylexButton = new StylexButton({
    height: PactMetric.BUTTON_HEIGHT_PRIMARY,
    size: StylexToken.FONT_BODY_LG,
    weight: FontWeight.Medium,
    color: StylexColor.ON_DARK,
    background: StylexColor.BRAND,
    radius: StylexToken.RADIUS_PILL,
    pressedBackground: StylexColor.BRAND_DEEP
  });

  static readonly GHOST: StylexButton = new StylexButton({
    height: PactMetric.BUTTON_HEIGHT_GHOST,
    size: StylexToken.FONT_LABEL,
    weight: FontWeight.Medium,
    color: StylexColor.BRAND,
    background: StylexColor.BRAND_SOFT,
    radius: StylexToken.RADIUS_PILL
  });

  static readonly DANGER: StylexButton = new StylexButton({
    height: PactMetric.BUTTON_HEIGHT_SMALL,
    size: StylexToken.FONT_LABEL,
    color: StylexColor.DANGER,
    background: StylexColor.DANGER_SOFT,
    radius: StylexToken.RADIUS_PILL
  });

  static readonly SMALL: StylexButton = new StylexButton({
    height: PactMetric.BUTTON_HEIGHT_SMALL,
    size: StylexToken.FONT_LABEL,
    color: StylexColor.ON_DARK,
    background: StylexColor.BRAND,
    radius: StylexToken.RADIUS_PILL,
    pressedBackground: StylexColor.BRAND_DEEP
  });
}

export class PactAccent {
  static forStage(stage: PactStage | string): ResourceColor {
    if (stage === PactStage.NEAR) {
      return StylexColor.SUCCESS;
    }
    if (stage === PactStage.MID) {
      return StylexColor.AMBER;
    }
    if (stage === PactStage.FAR) {
      return StylexColor.SLATE;
    }
    return StylexColor.BRAND;
  }

  static forLayer(layer: PactLayer | string): ResourceColor {
    if (layer === PactLayer.POLICY) {
      return StylexColor.BRAND;
    }
    if (layer === PactLayer.INDUSTRY) {
      return StylexColor.VIOLET;
    }
    if (layer === PactLayer.PERSONAL) {
      return StylexColor.AMBER;
    }
    return StylexColor.INK_SOFT;
  }
}
