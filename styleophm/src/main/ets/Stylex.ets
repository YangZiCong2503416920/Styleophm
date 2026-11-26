import { StylexToken } from './StylexTokens';

/**
 * 核心 AttributeModifier 实现。
 *
 * 设计约束：
 * 1. 构造时对 Spec 做显式浅拷贝 —— 外部对象后续被改动不会影响已创建的样式
 *    （AttributeModifier 每次渲染都会重跑 applyNormalAttribute，共享可变引用会造成隐藏副作用）；
 * 2. 颜色一律用 ResourceColor，既可传 `StylexColor.*`（跟随深浅色），也可传十六进制字符串；
 * 3. 边框颜色缺省补 `StylexToken.LINE`，避免只传宽度时被画成默认黑边。
 */

// -----------------------------------------------------------------------------
// Text
// -----------------------------------------------------------------------------

export interface StylexTextSpec {
  size?: number;
  weight?: FontWeight;
  color?: ResourceColor;
  lineHeight?: number;
  maxLines?: number;
  align?: TextAlign;
  letterSpacing?: number;
  /** maxLines 生效时是否补省略号，默认 true */
  ellipsis?: boolean;
  overflow?: TextOverflow;
  fontFamily?: string;
  decoration?: TextDecorationType;
  /** 以下为原 StylexTag 的能力，合并进来后 Text 也能直接带底色与内边距 */
  background?: ResourceColor;
  paddingH?: number;
  paddingV?: number;
  radius?: number;
}

export class StylexText implements AttributeModifier<TextAttribute> {
  private readonly spec: StylexTextSpec;

  constructor(spec: StylexTextSpec) {
    this.spec = copyTextSpec(spec);
  }

  applyNormalAttribute(instance: TextAttribute): void {
    applyTextSpec(this.spec, instance);
  }
}

/** @deprecated 等价于 StylexTextSpec；保留以兼容旧代码 */
export type StylexTagSpec = StylexTextSpec;

/** Text 的标签形态：继承 StylexText，不再重复实现一遍属性写入 */
export class StylexTag extends StylexText {
  constructor(spec: StylexTagSpec) {
    super(spec);
  }
}

// -----------------------------------------------------------------------------
// Column
// -----------------------------------------------------------------------------

export interface StylexBoxSpec {
  width?: Length;
  height?: Length;
  paddingTop?: number;
  paddingRight?: number;
  paddingBottom?: number;
  paddingLeft?: number;
  marginTop?: number;
  marginRight?: number;
  marginBottom?: number;
  marginLeft?: number;
  background?: ResourceColor;
  radius?: number;
  radiusTopLeft?: number;
  radiusTopRight?: number;
  radiusBottomLeft?: number;
  radiusBottomRight?: number;
  borderWidth?: number;
  borderTopWidth?: number;
  borderRightWidth?: number;
  borderBottomWidth?: number;
  borderLeftWidth?: number;
  borderColor?: ResourceColor;
  opacity?: number;
  /** 交叉轴对齐（Column） */
  alignItems?: HorizontalAlign;
  /** 主轴对齐 */
  justifyContent?: FlexAlign;
  layoutWeight?: number;
  flexGrow?: number;
  flexShrink?: number;
  clip?: boolean;
}

export class StylexBox implements AttributeModifier<ColumnAttribute> {
  private readonly spec: StylexBoxSpec;

  constructor(spec: StylexBoxSpec) {
    this.spec = copyBoxSpec(spec);
  }

  applyNormalAttribute(instance: ColumnAttribute): void {
    const spec: StylexBoxSpec = this.spec;
    if (spec.width !== undefined) {
      instance.width(spec.width);
    }
    if (spec.height !== undefined) {
      instance.height(spec.height);
    }
    if (hasInset(spec.paddingTop, spec.paddingRight, spec.paddingBottom, spec.paddingLeft)) {
      instance.padding({
        top: spec.paddingTop,
        right: spec.paddingRight,
        bottom: spec.paddingBottom,
        left: spec.paddingLeft
      });
    }
    if (hasInset(spec.marginTop, spec.marginRight, spec.marginBottom, spec.marginLeft)) {
      instance.margin({
        top: spec.marginTop,
        right: spec.marginRight,
        bottom: spec.marginBottom,
        left: spec.marginLeft
      });
    }
    if (spec.background !== undefined) {
      instance.backgroundColor(spec.background);
    }
    if (spec.radius !== undefined) {
      instance.borderRadius(spec.radius);
    }
    if (hasCorner(spec.radiusTopLeft, spec.radiusTopRight, spec.radiusBottomLeft, spec.radiusBottomRight)) {
      const base: number = spec.radius !== undefined ? spec.radius : 0;
      instance.borderRadius({
        topLeft: corner(spec.radiusTopLeft, base),
        topRight: corner(spec.radiusTopRight, base),
        bottomLeft: corner(spec.radiusBottomLeft, base),
        bottomRight: corner(spec.radiusBottomRight, base)
      });
    }
    if (spec.borderWidth !== undefined) {
      instance.border({ width: spec.borderWidth, color: borderColorOf(spec.borderColor) });
    }
    if (hasInset(spec.borderTopWidth, spec.borderRightWidth, spec.borderBottomWidth, spec.borderLeftWidth)) {
      instance.border({
        width: {
          top: spec.borderTopWidth,
          right: spec.borderRightWidth,
          bottom: spec.borderBottomWidth,
          left: spec.borderLeftWidth
        },
        color: borderColorOf(spec.borderColor)
      });
    }
    if (spec.opacity !== undefined) {
      instance.opacity(spec.opacity);
    }
    if (spec.alignItems !== undefined) {
      instance.alignItems(spec.alignItems);
    }
    if (spec.justifyContent !== undefined) {
      instance.justifyContent(spec.justifyContent);
    }
    if (spec.layoutWeight !== undefined) {
      instance.layoutWeight(spec.layoutWeight);
    }
    if (spec.flexGrow !== undefined) {
      instance.flexGrow(spec.flexGrow);
    }
    if (spec.flexShrink !== undefined) {
      instance.flexShrink(spec.flexShrink);
    }
    if (spec.clip !== undefined) {
      instance.clip(spec.clip);
    }
  }
}

// -----------------------------------------------------------------------------
// Button
// -----------------------------------------------------------------------------

export interface StylexButtonSpec {
  width?: Length;
  height?: number;
  size?: number;
  weight?: FontWeight;
  color?: ResourceColor;
  background?: ResourceColor;
  radius?: number;
  /** 是否保留系统按下的水波纹/缩放反馈，默认交给系统 */
  stateEffect?: boolean;
  /** 按下时的背景色，不设则只做透明度反馈 */
  pressedBackground?: ResourceColor;
  /** 按下时的透明度，默认 0.82 */
  pressedOpacity?: number;
}

export class StylexButton implements AttributeModifier<ButtonAttribute> {
  private readonly spec: StylexButtonSpec;

  constructor(spec: StylexButtonSpec) {
    this.spec = copyButtonSpec(spec);
  }

  applyNormalAttribute(instance: ButtonAttribute): void {
    const spec: StylexButtonSpec = this.spec;
    if (spec.width !== undefined) {
      instance.width(spec.width);
    }
    if (spec.height !== undefined) {
      instance.height(spec.height);
    }
    if (spec.size !== undefined) {
      instance.fontSize(spec.size);
    }
    if (spec.weight !== undefined) {
      instance.fontWeight(spec.weight);
    }
    if (spec.color !== undefined) {
      instance.fontColor(spec.color);
    }
    if (spec.background !== undefined) {
      instance.backgroundColor(spec.background);
    }
    if (spec.radius !== undefined) {
      instance.borderRadius(spec.radius);
    }
    if (spec.stateEffect !== undefined) {
      instance.stateEffect(spec.stateEffect);
    }
  }

  /** 按下态：AttributeModifier 的 pressed 分支，补上原实现缺失的点击反馈 */
  applyPressedAttribute(instance: ButtonAttribute): void {
    const spec: StylexButtonSpec = this.spec;
    if (spec.pressedBackground !== undefined) {
      instance.backgroundColor(spec.pressedBackground);
    }
    instance.opacity(spec.pressedOpacity !== undefined ? spec.pressedOpacity : 0.82);
  }
}

// -----------------------------------------------------------------------------
// Row
// -----------------------------------------------------------------------------

export interface StylexRowSpec {
  width?: Length;
  height?: Length;
  paddingTop?: number;
  paddingRight?: number;
  paddingBottom?: number;
  paddingLeft?: number;
  marginTop?: number;
  marginRight?: number;
  marginBottom?: number;
  marginLeft?: number;
  background?: ResourceColor;
  radius?: number;
  radiusTopLeft?: number;
  radiusTopRight?: number;
  radiusBottomLeft?: number;
  radiusBottomRight?: number;
  borderWidth?: number;
  borderTopWidth?: number;
  borderRightWidth?: number;
  borderBottomWidth?: number;
  borderLeftWidth?: number;
  borderColor?: ResourceColor;
  opacity?: number;
  /** 交叉轴对齐（Row 用 VerticalAlign） */
  alignItems?: VerticalAlign;
  /** 主轴对齐 */
  justifyContent?: FlexAlign;
  layoutWeight?: number;
  flexGrow?: number;
  flexShrink?: number;
  clip?: boolean;
}

export class StylexRow implements AttributeModifier<RowAttribute> {
  private readonly spec: StylexRowSpec;

  constructor(spec: StylexRowSpec) {
    this.spec = copyRowSpec(spec);
  }

  applyNormalAttribute(instance: RowAttribute): void {
    const spec: StylexRowSpec = this.spec;
    if (spec.width !== undefined) {
      instance.width(spec.width);
    }
    if (spec.height !== undefined) {
      instance.height(spec.height);
    }
    if (hasInset(spec.paddingTop, spec.paddingRight, spec.paddingBottom, spec.paddingLeft)) {
      instance.padding({
        top: spec.paddingTop,
        right: spec.paddingRight,
        bottom: spec.paddingBottom,
        left: spec.paddingLeft
      });
    }
    if (hasInset(spec.marginTop, spec.marginRight, spec.marginBottom, spec.marginLeft)) {
      instance.margin({
        top: spec.marginTop,
        right: spec.marginRight,
        bottom: spec.marginBottom,
        left: spec.marginLeft
      });
    }
    if (spec.background !== undefined) {
      instance.backgroundColor(spec.background);
    }
    if (spec.radius !== undefined) {
      instance.borderRadius(spec.radius);
    }
    if (hasCorner(spec.radiusTopLeft, spec.radiusTopRight, spec.radiusBottomLeft, spec.radiusBottomRight)) {
      const base: number = spec.radius !== undefined ? spec.radius : 0;
      instance.borderRadius({
        topLeft: corner(spec.radiusTopLeft, base),
        topRight: corner(spec.radiusTopRight, base),
        bottomLeft: corner(spec.radiusBottomLeft, base),
        bottomRight: corner(spec.radiusBottomRight, base)
      });
    }
    if (spec.borderWidth !== undefined) {
      instance.border({ width: spec.borderWidth, color: borderColorOf(spec.borderColor) });
    }
    if (hasInset(spec.borderTopWidth, spec.borderRightWidth, spec.borderBottomWidth, spec.borderLeftWidth)) {
      instance.border({
        width: {
          top: spec.borderTopWidth,
          right: spec.borderRightWidth,
          bottom: spec.borderBottomWidth,
          left: spec.borderLeftWidth
        },
        color: borderColorOf(spec.borderColor)
      });
    }
    if (spec.opacity !== undefined) {
      instance.opacity(spec.opacity);
    }
    if (spec.alignItems !== undefined) {
      instance.alignItems(spec.alignItems);
    }
    if (spec.justifyContent !== undefined) {
      instance.justifyContent(spec.justifyContent);
    }
    if (spec.layoutWeight !== undefined) {
      instance.layoutWeight(spec.layoutWeight);
    }
    if (spec.flexGrow !== undefined) {
      instance.flexGrow(spec.flexGrow);
    }
    if (spec.flexShrink !== undefined) {
      instance.flexShrink(spec.flexShrink);
    }
    if (spec.clip !== undefined) {
      instance.clip(spec.clip);
    }
  }
}

// -----------------------------------------------------------------------------
// 内部工具
// -----------------------------------------------------------------------------

function borderColorOf(color: ResourceColor | undefined): ResourceColor {
  return color !== undefined ? color : StylexToken.LINE;
}

function hasInset(top: number | undefined, right: number | undefined,
  bottom: number | undefined, left: number | undefined): boolean {
  return top !== undefined || right !== undefined || bottom !== undefined || left !== undefined;
}

function hasCorner(topLeft: number | undefined, topRight: number | undefined,
  bottomLeft: number | undefined, bottomRight: number | undefined): boolean {
  return topLeft !== undefined || topRight !== undefined || bottomLeft !== undefined || bottomRight !== undefined;
}

function corner(value: number | undefined, base: number): number {
  return value !== undefined ? value : base;
}

function applyTextSpec(spec: StylexTextSpec, instance: TextAttribute): void {
  if (spec.size !== undefined) {
    instance.fontSize(spec.size);
  }
  if (spec.weight !== undefined) {
    instance.fontWeight(spec.weight);
  }
  if (spec.color !== undefined) {
    instance.fontColor(spec.color);
  }
  if (spec.lineHeight !== undefined) {
    instance.lineHeight(spec.lineHeight);
  }
  if (spec.align !== undefined) {
    instance.textAlign(spec.align);
  }
  if (spec.letterSpacing !== undefined) {
    instance.letterSpacing(spec.letterSpacing);
  }
  if (spec.fontFamily !== undefined) {
    instance.fontFamily(spec.fontFamily);
  }
  if (spec.decoration !== undefined) {
    instance.decoration({ type: spec.decoration });
  }
  if (spec.background !== undefined) {
    instance.backgroundColor(spec.background);
  }
  if (spec.paddingH !== undefined || spec.paddingV !== undefined) {
    instance.padding({
      left: spec.paddingH,
      right: spec.paddingH,
      top: spec.paddingV,
      bottom: spec.paddingV
    });
  }
  if (spec.radius !== undefined) {
    instance.borderRadius(spec.radius);
  }
  if (spec.maxLines !== undefined) {
    instance.maxLines(spec.maxLines);
    instance.textOverflow({ overflow: resolveOverflow(spec) });
  } else if (spec.overflow !== undefined) {
    instance.textOverflow({ overflow: spec.overflow });
  }
}

function resolveOverflow(spec: StylexTextSpec): TextOverflow {
  if (spec.overflow !== undefined) {
    return spec.overflow;
  }
  return spec.ellipsis === false ? TextOverflow.Clip : TextOverflow.Ellipsis;
}

function copyTextSpec(spec: StylexTextSpec): StylexTextSpec {
  return {
    size: spec.size,
    weight: spec.weight,
    color: spec.color,
    lineHeight: spec.lineHeight,
    maxLines: spec.maxLines,
    align: spec.align,
    letterSpacing: spec.letterSpacing,
    ellipsis: spec.ellipsis,
    overflow: spec.overflow,
    fontFamily: spec.fontFamily,
    decoration: spec.decoration,
    background: spec.background,
    paddingH: spec.paddingH,
    paddingV: spec.paddingV,
    radius: spec.radius
  };
}

function copyBoxSpec(spec: StylexBoxSpec): StylexBoxSpec {
  return {
    width: spec.width,
    height: spec.height,
    paddingTop: spec.paddingTop,
    paddingRight: spec.paddingRight,
    paddingBottom: spec.paddingBottom,
    paddingLeft: spec.paddingLeft,
    marginTop: spec.marginTop,
    marginRight: spec.marginRight,
    marginBottom: spec.marginBottom,
    marginLeft: spec.marginLeft,
    background: spec.background,
    radius: spec.radius,
    radiusTopLeft: spec.radiusTopLeft,
    radiusTopRight: spec.radiusTopRight,
    radiusBottomLeft: spec.radiusBottomLeft,
    radiusBottomRight: spec.radiusBottomRight,
    borderWidth: spec.borderWidth,
    borderTopWidth: spec.borderTopWidth,
    borderRightWidth: spec.borderRightWidth,
    borderBottomWidth: spec.borderBottomWidth,
    borderLeftWidth: spec.borderLeftWidth,
    borderColor: spec.borderColor,
    opacity: spec.opacity,
    alignItems: spec.alignItems,
    justifyContent: spec.justifyContent,
    layoutWeight: spec.layoutWeight,
    flexGrow: spec.flexGrow,
    flexShrink: spec.flexShrink,
    clip: spec.clip
  };
}

function copyButtonSpec(spec: StylexButtonSpec): StylexButtonSpec {
  return {
    width: spec.width,
    height: spec.height,
    size: spec.size,
    weight: spec.weight,
    color: spec.color,
    background: spec.background,
    radius: spec.radius,
    stateEffect: spec.stateEffect,
    pressedBackground: spec.pressedBackground,
    pressedOpacity: spec.pressedOpacity
  };
}

function copyRowSpec(spec: StylexRowSpec): StylexRowSpec {
  return {
    width: spec.width,
    height: spec.height,
    paddingTop: spec.paddingTop,
    paddingRight: spec.paddingRight,
    paddingBottom: spec.paddingBottom,
    paddingLeft: spec.paddingLeft,
    marginTop: spec.marginTop,
    marginRight: spec.marginRight,
    marginBottom: spec.marginBottom,
    marginLeft: spec.marginLeft,
    background: spec.background,
    radius: spec.radius,
    radiusTopLeft: spec.radiusTopLeft,
    radiusTopRight: spec.radiusTopRight,
    radiusBottomLeft: spec.radiusBottomLeft,
    radiusBottomRight: spec.radiusBottomRight,
    borderWidth: spec.borderWidth,
    borderTopWidth: spec.borderTopWidth,
    borderRightWidth: spec.borderRightWidth,
    borderBottomWidth: spec.borderBottomWidth,
    borderLeftWidth: spec.borderLeftWidth,
    borderColor: spec.borderColor,
    opacity: spec.opacity,
    alignItems: spec.alignItems,
    justifyContent: spec.justifyContent,
    layoutWeight: spec.layoutWeight,
    flexGrow: spec.flexGrow,
    flexShrink: spec.flexShrink,
    clip: spec.clip
  };
}
