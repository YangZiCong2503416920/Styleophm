import { StylexBox, StylexButton, StylexTag, StylexText } from './Stylex';
import { StylexToken } from './StylexTokens';

export class PactText {
  static readonly DISPLAY: StylexText = new StylexText({
    size: StylexToken.FONT_DISPLAY,
    weight: FontWeight.Bold,
    color: StylexToken.INK,
    lineHeight: 32
  });

  static readonly HERO: StylexText = new StylexText({
    size: StylexToken.FONT_TITLE,
    weight: FontWeight.Bold,
    color: StylexToken.INK,
    lineHeight: 27
  });

  static readonly HERO_ON_DARK: StylexText = new StylexText({
    size: StylexToken.FONT_TITLE,
    weight: FontWeight.Bold,
    color: '#FFFFFF',
    lineHeight: 27
  });

  static readonly TITLE: StylexText = new StylexText({
    size: StylexToken.FONT_TITLE,
    weight: FontWeight.Bold,
    color: StylexToken.INK,
    lineHeight: 24
  });

  static readonly SUBTITLE: StylexText = new StylexText({
    size: StylexToken.FONT_LABEL,
    color: StylexToken.INK_SOFT,
    lineHeight: 18
  });

  static readonly BODY: StylexText = new StylexText({
    size: StylexToken.FONT_BODY,
    color: StylexToken.INK,
    lineHeight: StylexToken.LINE_BODY
  });

  static readonly BODY_SOFT: StylexText = new StylexText({
    size: StylexToken.FONT_BODY,
    color: StylexToken.INK_SOFT,
    lineHeight: 21
  });

  static readonly ACTION: StylexText = new StylexText({
    size: StylexToken.FONT_BODY,
    color: StylexToken.INK,
    lineHeight: 21
  });

  static readonly QUOTE: StylexText = new StylexText({
    size: StylexToken.FONT_BODY_LG,
    color: StylexToken.INK,
    lineHeight: StylexToken.LINE_LOOSE
  });

  static readonly LABEL: StylexText = new StylexText({
    size: StylexToken.FONT_LABEL,
    color: StylexToken.INK_SOFT,
    lineHeight: 18
  });

  static readonly CAPTION: StylexText = new StylexText({
    size: StylexToken.FONT_CAPTION,
    color: StylexToken.INK_FAINT,
    lineHeight: 16
  });

  static readonly CAPTION_ON_DARK: StylexText = new StylexText({
    size: StylexToken.FONT_CAPTION,
    color: '#C9D6EC',
    lineHeight: 16
  });

  static readonly TOGGLE: StylexText = new StylexText({
    size: StylexToken.FONT_LABEL,
    weight: FontWeight.Medium,
    color: StylexToken.BRAND,
    lineHeight: 18
  });
}

export class PactBox {
  static readonly CARD: StylexBox = new StylexBox({
    background: StylexToken.SURFACE,
    radius: StylexToken.RADIUS_MD,
    paddingTop: StylexToken.SPACE_LG,
    paddingRight: StylexToken.SPACE_LG,
    paddingBottom: StylexToken.SPACE_LG,
    paddingLeft: StylexToken.SPACE_LG
  });

  static readonly HERO: StylexBox = new StylexBox({
    background: StylexToken.BRAND,
    radius: 20,
    paddingTop: 18,
    paddingRight: 18,
    paddingBottom: 18,
    paddingLeft: 18
  });

  static readonly SOFT: StylexBox = new StylexBox({
    background: StylexToken.BRAND_SOFT,
    radius: 14,
    paddingTop: 14,
    paddingRight: 14,
    paddingBottom: 14,
    paddingLeft: 14
  });

  static readonly QUOTE: StylexBox = new StylexBox({
    background: '#F8FAFD',
    radius: 14,
    paddingTop: StylexToken.SPACE_LG,
    paddingRight: StylexToken.SPACE_LG,
    paddingBottom: StylexToken.SPACE_LG,
    paddingLeft: StylexToken.SPACE_LG,
    borderWidth: 1,
    borderColor: StylexToken.LINE
  });
}

export class PactTag {
  private static readonly POLICY: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexToken.BRAND,
    background: StylexToken.BRAND_SOFT,
    paddingH: 9,
    paddingV: 3,
    radius: 9
  });

  private static readonly INDUSTRY: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexToken.VIOLET,
    background: StylexToken.VIOLET_SOFT,
    paddingH: 9,
    paddingV: 3,
    radius: 9
  });

  private static readonly PERSONAL: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexToken.AMBER,
    background: StylexToken.GOLD_SOFT,
    paddingH: 9,
    paddingV: 3,
    radius: 9
  });

  private static readonly STAGE_NEAR: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexToken.SUCCESS,
    background: StylexToken.GREEN_SOFT,
    paddingH: 10,
    paddingV: 3,
    radius: 9
  });

  private static readonly STAGE_MID: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexToken.AMBER,
    background: StylexToken.AMBER_SOFT,
    paddingH: 10,
    paddingV: 3,
    radius: 9
  });

  private static readonly STAGE_FAR: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexToken.SLATE,
    background: StylexToken.SLATE_SOFT,
    paddingH: 10,
    paddingV: 3,
    radius: 9
  });

  private static readonly NEUTRAL: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: StylexToken.INK_SOFT,
    background: '#F1F3F8',
    paddingH: 9,
    paddingV: 3,
    radius: 9
  });

  static readonly ON_DARK: StylexTag = new StylexTag({
    size: StylexToken.FONT_CAPTION,
    weight: FontWeight.Medium,
    color: '#F0D98A',
    background: '#2A4A72',
    paddingH: 9,
    paddingV: 3,
    radius: 9
  });

  static forLayer(layer: string): StylexTag {
    if (layer === '政策层') {
      return PactTag.POLICY;
    }
    if (layer === '行业层') {
      return PactTag.INDUSTRY;
    }
    if (layer === '个人层') {
      return PactTag.PERSONAL;
    }
    return PactTag.NEUTRAL;
  }

  static forStage(stage: string): StylexTag {
    if (stage === '近期') {
      return PactTag.STAGE_NEAR;
    }
    if (stage === '中期') {
      return PactTag.STAGE_MID;
    }
    if (stage === '远期') {
      return PactTag.STAGE_FAR;
    }
    return PactTag.NEUTRAL;
  }
}

export class PactButton {
  static readonly PRIMARY: StylexButton = new StylexButton({
    height: 46,
    size: StylexToken.FONT_BODY_LG,
    weight: FontWeight.Medium,
    color: '#FFFFFF',
    background: StylexToken.BRAND,
    radius: 23
  });

  static readonly GHOST: StylexButton = new StylexButton({
    height: 40,
    size: StylexToken.FONT_LABEL,
    weight: FontWeight.Medium,
    color: StylexToken.BRAND,
    background: StylexToken.BRAND_SOFT,
    radius: 20
  });

  static readonly DANGER: StylexButton = new StylexButton({
    height: 34,
    size: StylexToken.FONT_LABEL,
    color: StylexToken.DANGER,
    background: '#FBEDEB',
    radius: 17
  });

  static readonly SMALL: StylexButton = new StylexButton({
    height: 34,
    size: StylexToken.FONT_LABEL,
    color: '#FFFFFF',
    background: StylexToken.BRAND,
    radius: 17
  });
}

export class PactAccent {
  static forStage(stage: string): string {
    if (stage === '近期') {
      return StylexToken.SUCCESS;
    }
    if (stage === '中期') {
      return StylexToken.AMBER;
    }
    if (stage === '远期') {
      return StylexToken.SLATE;
    }
    return StylexToken.BRAND;
  }

  static forLayer(layer: string): string {
    if (layer === '政策层') {
      return StylexToken.BRAND;
    }
    if (layer === '行业层') {
      return StylexToken.VIOLET;
    }
    if (layer === '个人层') {
      return StylexToken.AMBER;
    }
    return StylexToken.INK_SOFT;
  }
}
