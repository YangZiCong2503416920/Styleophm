export interface StylexTextSpec {
  size?: number;
  weight?: FontWeight;
  color?: string;
  lineHeight?: number;
  maxLines?: number;
  align?: TextAlign;
  letterSpacing?: number;
}

export class StylexText implements AttributeModifier<TextAttribute> {
  private readonly spec: StylexTextSpec;

  constructor(spec: StylexTextSpec) {
    this.spec = spec;
  }

  applyNormalAttribute(instance: TextAttribute): void {
    if (this.spec.size !== undefined) {
      instance.fontSize(this.spec.size);
    }
    if (this.spec.weight !== undefined) {
      instance.fontWeight(this.spec.weight);
    }
    if (this.spec.color !== undefined) {
      instance.fontColor(this.spec.color);
    }
    if (this.spec.lineHeight !== undefined) {
      instance.lineHeight(this.spec.lineHeight);
    }
    if (this.spec.maxLines !== undefined) {
      instance.maxLines(this.spec.maxLines);
    }
    if (this.spec.align !== undefined) {
      instance.textAlign(this.spec.align);
    }
    if (this.spec.letterSpacing !== undefined) {
      instance.letterSpacing(this.spec.letterSpacing);
    }
  }
}

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
  background?: string;
  radius?: number;
  borderWidth?: number;
  borderColor?: string;
  borderLeftWidth?: number;
  opacity?: number;
}

export class StylexBox implements AttributeModifier<ColumnAttribute> {
  private readonly spec: StylexBoxSpec;

  constructor(spec: StylexBoxSpec) {
    this.spec = spec;
  }

  applyNormalAttribute(instance: ColumnAttribute): void {
    if (this.spec.width !== undefined) {
      instance.width(this.spec.width);
    }
    if (this.spec.height !== undefined) {
      instance.height(this.spec.height);
    }
    if (this.spec.paddingTop !== undefined || this.spec.paddingRight !== undefined ||
      this.spec.paddingBottom !== undefined || this.spec.paddingLeft !== undefined) {
      instance.padding({
        top: this.spec.paddingTop,
        right: this.spec.paddingRight,
        bottom: this.spec.paddingBottom,
        left: this.spec.paddingLeft
      });
    }
    if (this.spec.marginTop !== undefined || this.spec.marginRight !== undefined ||
      this.spec.marginBottom !== undefined || this.spec.marginLeft !== undefined) {
      instance.margin({
        top: this.spec.marginTop,
        right: this.spec.marginRight,
        bottom: this.spec.marginBottom,
        left: this.spec.marginLeft
      });
    }
    if (this.spec.background !== undefined) {
      instance.backgroundColor(this.spec.background);
    }
    if (this.spec.radius !== undefined) {
      instance.borderRadius(this.spec.radius);
    }
    if (this.spec.borderWidth !== undefined) {
      instance.border({ width: this.spec.borderWidth, color: this.spec.borderColor });
    }
    if (this.spec.borderLeftWidth !== undefined) {
      instance.border({ width: { left: this.spec.borderLeftWidth }, color: this.spec.borderColor });
    }
    if (this.spec.opacity !== undefined) {
      instance.opacity(this.spec.opacity);
    }
  }
}

export interface StylexTagSpec {
  size?: number;
  weight?: FontWeight;
  color?: string;
  background?: string;
  paddingH?: number;
  paddingV?: number;
  radius?: number;
  maxLines?: number;
}

export class StylexTag implements AttributeModifier<TextAttribute> {
  private readonly spec: StylexTagSpec;

  constructor(spec: StylexTagSpec) {
    this.spec = spec;
  }

  applyNormalAttribute(instance: TextAttribute): void {
    if (this.spec.size !== undefined) {
      instance.fontSize(this.spec.size);
    }
    if (this.spec.weight !== undefined) {
      instance.fontWeight(this.spec.weight);
    }
    if (this.spec.color !== undefined) {
      instance.fontColor(this.spec.color);
    }
    if (this.spec.background !== undefined) {
      instance.backgroundColor(this.spec.background);
    }
    if (this.spec.paddingH !== undefined || this.spec.paddingV !== undefined) {
      instance.padding({
        left: this.spec.paddingH,
        right: this.spec.paddingH,
        top: this.spec.paddingV,
        bottom: this.spec.paddingV
      });
    }
    if (this.spec.radius !== undefined) {
      instance.borderRadius(this.spec.radius);
    }
    if (this.spec.maxLines !== undefined) {
      instance.maxLines(this.spec.maxLines);
    }
  }
}

export interface StylexButtonSpec {
  height?: number;
  size?: number;
  weight?: FontWeight;
  color?: string;
  background?: string;
  radius?: number;
}

export class StylexButton implements AttributeModifier<ButtonAttribute> {
  private readonly spec: StylexButtonSpec;

  constructor(spec: StylexButtonSpec) {
    this.spec = spec;
  }

  applyNormalAttribute(instance: ButtonAttribute): void {
    if (this.spec.height !== undefined) {
      instance.height(this.spec.height);
    }
    if (this.spec.size !== undefined) {
      instance.fontSize(this.spec.size);
    }
    if (this.spec.weight !== undefined) {
      instance.fontWeight(this.spec.weight);
    }
    if (this.spec.color !== undefined) {
      instance.fontColor(this.spec.color);
    }
    if (this.spec.background !== undefined) {
      instance.backgroundColor(this.spec.background);
    }
    if (this.spec.radius !== undefined) {
      instance.borderRadius(this.spec.radius);
    }
  }
}

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
  background?: string;
  radius?: number;
  borderBottomWidth?: number;
  borderColor?: string;
}

export class StylexRow implements AttributeModifier<RowAttribute> {
  private readonly spec: StylexRowSpec;

  constructor(spec: StylexRowSpec) {
    this.spec = spec;
  }

  applyNormalAttribute(instance: RowAttribute): void {
    if (this.spec.width !== undefined) {
      instance.width(this.spec.width);
    }
    if (this.spec.height !== undefined) {
      instance.height(this.spec.height);
    }
    if (this.spec.paddingTop !== undefined || this.spec.paddingRight !== undefined ||
      this.spec.paddingBottom !== undefined || this.spec.paddingLeft !== undefined) {
      instance.padding({
        top: this.spec.paddingTop,
        right: this.spec.paddingRight,
        bottom: this.spec.paddingBottom,
        left: this.spec.paddingLeft
      });
    }
    if (this.spec.marginTop !== undefined || this.spec.marginRight !== undefined ||
      this.spec.marginBottom !== undefined || this.spec.marginLeft !== undefined) {
      instance.margin({
        top: this.spec.marginTop,
        right: this.spec.marginRight,
        bottom: this.spec.marginBottom,
        left: this.spec.marginLeft
      });
    }
    if (this.spec.background !== undefined) {
      instance.backgroundColor(this.spec.background);
    }
    if (this.spec.radius !== undefined) {
      instance.borderRadius(this.spec.radius);
    }
    if (this.spec.borderBottomWidth !== undefined) {
      instance.border({ width: { bottom: this.spec.borderBottomWidth }, color: this.spec.borderColor });
    }
  }
}
