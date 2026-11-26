import {
  PactAccent,
  PactBox,
  PactButton,
  PactLayer,
  PactStage,
  PactTag,
  PactText,
  StylexBox,
  StylexColor,
  StylexRow,
  StylexText,
  StylexToken
} from 'styleophm';

// -----------------------------------------------------------------------------
// 页面级样式：同样是「先建对象，再 attributeModifier」，不是内联魔法数字
// -----------------------------------------------------------------------------

const PAGE_BOX: StylexBox = new StylexBox({
  width: '100%',
  background: StylexColor.CANVAS,
  paddingTop: StylexToken.SPACE_LG,
  paddingRight: StylexToken.SPACE_LG,
  paddingBottom: StylexToken.SPACE_2XL,
  paddingLeft: StylexToken.SPACE_LG
});

const SECTION_BOX: StylexBox = new StylexBox({
  background: StylexColor.SURFACE,
  radius: StylexToken.RADIUS_LG,
  paddingTop: StylexToken.SPACE_LG,
  paddingRight: StylexToken.SPACE_LG,
  paddingBottom: StylexToken.SPACE_LG,
  paddingLeft: StylexToken.SPACE_LG,
  marginBottom: StylexToken.SPACE_MD,
  alignItems: HorizontalAlign.Start
});

const NOTICE_BOX: StylexBox = new StylexBox({
  background: StylexColor.GOLD_SOFT,
  radius: StylexToken.RADIUS_MD,
  paddingTop: StylexToken.SPACE_MD,
  paddingRight: StylexToken.SPACE_MD,
  paddingBottom: StylexToken.SPACE_MD,
  paddingLeft: StylexToken.SPACE_MD,
  borderWidth: 1,
  borderColor: StylexColor.GOLD,
  marginTop: StylexToken.SPACE_SM,
  alignItems: HorizontalAlign.Start
});

const NOTICE_TEXT: StylexText = new StylexText({
  size: StylexToken.FONT_BODY,
  color: StylexColor.AMBER,
  lineHeight: StylexToken.LINE_BODY
});

const LAYOUT_ROW: StylexRow = new StylexRow({
  width: '100%',
  background: StylexColor.SURFACE_SOFT,
  radius: StylexToken.RADIUS_MD,
  paddingTop: StylexToken.SPACE_MD,
  paddingRight: StylexToken.SPACE_MD,
  paddingBottom: StylexToken.SPACE_MD,
  paddingLeft: StylexToken.SPACE_MD,
  borderWidth: 1,
  borderColor: StylexColor.LINE,
  alignItems: VerticalAlign.Center,
  justifyContent: FlexAlign.SpaceBetween
});

@Entry
@Component
struct Index {
  private readonly layers: string[] = [PactLayer.POLICY, PactLayer.INDUSTRY, PactLayer.PERSONAL];
  private readonly stages: string[] = [PactStage.NEAR, PactStage.MID, PactStage.FAR];

  build() {
    Scroll() {
      Column() {
        this.hero()
        this.typography()
        this.chips()
        this.buttons()
        this.layout()
        this.custom()
      }
      .attributeModifier(PAGE_BOX)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .align(Alignment.Top)
  }

  @Builder
  hero() {
    Column() {
      Row() {
        Text('Styleophm').attributeModifier(PactText.HERO_ON_DARK).layoutWeight(1)
        Text('v1.0.0').attributeModifier(PactTag.ON_DARK)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Text('token 驱动 · 类型安全 · 深色自适应')
        .attributeModifier(PactText.CAPTION_ON_DARK)
        .margin({ top: StylexToken.SPACE_XS })
    }
    .attributeModifier(PactBox.HERO)
    .margin({ bottom: StylexToken.SPACE_MD })
  }

  @Builder
  typography() {
    Column() {
      Text('排版刻度').attributeModifier(PactText.TITLE).margin({ bottom: StylexToken.SPACE_SM })
      Text('DISPLAY 24 / Bold').attributeModifier(PactText.DISPLAY)
      Text('HERO 17 / Bold').attributeModifier(PactText.HERO).margin({ top: StylexToken.SPACE_SM })
      Text('TITLE 17 / Bold').attributeModifier(PactText.TITLE).margin({ top: StylexToken.SPACE_XS })
      Text('SUBTITLE 12 / 次级说明').attributeModifier(PactText.SUBTITLE).margin({ top: StylexToken.SPACE_XS })
      Text('BODY 14 / 正文内容，用来验证行高与深色前景色是否跟随系统切换。')
        .attributeModifier(PactText.BODY)
        .margin({ top: StylexToken.SPACE_SM })
      Text('CAPTION 11 / 注释').attributeModifier(PactText.CAPTION).margin({ top: StylexToken.SPACE_XS })

      Column() {
        Text('QUOTE 15 / 引用块：样式只创建一次，可跨组件复用，并被 ArkTS 严格模式完整检查。')
          .attributeModifier(PactText.QUOTE)
      }
      .attributeModifier(PactBox.QUOTE)
      .margin({ top: StylexToken.SPACE_MD })
    }
    .attributeModifier(SECTION_BOX)
  }

  @Builder
  chips() {
    Column() {
      Text('标签与阶段').attributeModifier(PactText.TITLE).margin({ bottom: StylexToken.SPACE_SM })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.layers, (layer: string) => {
          Text(layer).attributeModifier(PactTag.forLayer(layer)).margin({ right: StylexToken.SPACE_SM })
        }, (layer: string) => layer)
      }
      .width('100%')

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.stages, (stage: string) => {
          Text(stage)
            .attributeModifier(PactTag.forStage(stage))
            .fontColor(PactAccent.forStage(stage))
            .margin({ right: StylexToken.SPACE_SM })
        }, (stage: string) => stage)
      }
      .width('100%')
      .margin({ top: StylexToken.SPACE_SM })
    }
    .attributeModifier(SECTION_BOX)
  }

  @Builder
  buttons() {
    Column() {
      Text('按钮（含按压态）').attributeModifier(PactText.TITLE).margin({ bottom: StylexToken.SPACE_SM })

      Row({ space: StylexToken.SPACE_SM }) {
        Button('主操作')
          .attributeModifier(PactButton.PRIMARY)
          .layoutWeight(1)
        Button('次要')
          .attributeModifier(PactButton.GHOST)
          .layoutWeight(1)
      }
      .width('100%')

      Row({ space: StylexToken.SPACE_SM }) {
        Button('小按钮')
          .attributeModifier(PactButton.SMALL)
          .layoutWeight(1)
        Button('危险')
          .attributeModifier(PactButton.DANGER)
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: StylexToken.SPACE_SM })

      Text('PRIMARY / SMALL 按下时切到 BRAND_DEEP，其余走透明度反馈。')
        .attributeModifier(PactText.CAPTION)
        .margin({ top: StylexToken.SPACE_SM })
    }
    .attributeModifier(SECTION_BOX)
  }

  @Builder
  layout() {
    Column() {
      Text('容器能力').attributeModifier(PactText.TITLE).margin({ bottom: StylexToken.SPACE_SM })

      Row() {
        Text('alignItems / justifyContent 已内建').attributeModifier(PactText.LABEL)
        Text('row').attributeModifier(PactTag.ON_DARK)
      }
      .attributeModifier(LAYOUT_ROW)

      Row() {
        Text('layoutWeight 把剩余空间分给左侧文本').attributeModifier(PactText.BODY).layoutWeight(1)
        Text('固定').attributeModifier(PactText.LABEL)
      }
      .width('100%')
      .padding({ top: StylexToken.SPACE_SM, bottom: StylexToken.SPACE_SM })
      .alignItems(VerticalAlign.Center)
    }
    .attributeModifier(SECTION_BOX)
  }

  @Builder
  custom() {
    Column() {
      Text('自定义样式').attributeModifier(PactText.TITLE).margin({ bottom: StylexToken.SPACE_SM })

      Column() {
        Text('自定义修饰器：由 StylexBox / StylexText 组合，颜色来自 StylexColor，无需写死色值。')
          .attributeModifier(NOTICE_TEXT)
      }
      .attributeModifier(NOTICE_BOX)

      Text('主题切换：把系统切到深色，本页所有颜色会随 resources/dark 自动变化，无需重启。')
        .attributeModifier(PactText.CAPTION)
        .margin({ top: StylexToken.SPACE_SM })
    }
    .attributeModifier(SECTION_BOX)
  }
}
