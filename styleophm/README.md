# styleophm

Typed style primitives and design tokens for **HarmonyOS ArkUI** — named tokens plus reusable
`AttributeModifier` presets, so a style is written once and rendered everywhere.

ArkTS strict mode forbids dynamic style objects (`arkts-no-props-by-index`, `arkts-no-untyped-obj-literals`),
so the Web `StyleX` approach does not compile. Styleophm takes the same idea and expresses it with
`AttributeModifier`: a style becomes a typed class instance that you attach with one line.

```ts
import { PactText, PactBox, PactButton } from 'styleophm';

Text('五年规划').attributeModifier(PactText.HERO)
Column() { /* ... */ }.attributeModifier(PactBox.CARD)
Button('保存').attributeModifier(PactButton.PRIMARY)
```

## Why not `@Styles` / `@Extend`

| | `@Styles` | `@Extend(Text)` | styleophm |
|---|---|---|---|
| Cross-file reuse | import a static method | file-scoped only | yes |
| Parameters | not supported | wrap manually | yes (typed `Spec`) |
| Reuse cost | regenerated per call | regenerated per call | one static instance |
| Design tokens / dark mode | hard-coded colours | hard-coded colours | `StylexColor` resources |
| Pressed state | no | no | `applyPressedAttribute` |

## Install

```json5
// in the consumer module's oh-package.json5
{
  "dependencies": {
    "styleophm": "file:./libs/styleophm.har"
  }
}
```

```bash
ohpm install
```

## What you get

- 5 modifiers: `StylexText` / `StylexBox` / `StylexTag` / `StylexButton` / `StylexRow`
  (sizing, four-side padding & margin, per-corner radius, per-side border, `alignItems`,
  `justifyContent`, `layoutWeight`, `flexGrow`, `flexShrink`, pressed state, ellipsis)
- 2 token layers: `StylexToken` (spacing / radius / font / line-height / hex colours)
  and `StylexColor` (33 resource colours, `base` + `dark`, follows the system theme)
- Presets: `PactText` / `PactBox` / `PactTag` / `PactButton` / `PactAccent` + `PactLayer` / `PactStage` enums
- Colours are resource-backed, so switching the system to dark mode flips the whole UI without a restart

```ts
import { StylexBox, StylexColor, StylexToken } from 'styleophm';

const NoticeBox: StylexBox = new StylexBox({
  background: StylexColor.GOLD_SOFT,
  radius: StylexToken.RADIUS_MD,
  borderWidth: 1,
  borderColor: StylexColor.GOLD,
  alignItems: HorizontalAlign.Start
});
```

## Notes

- Requires `compatibleSdkVersion 6.1.1(24)` or newer, ArkTS strict mode, module type HAR.
- Resource names are prefixed with `stylex_` on purpose: an unprefixed `app.color.brand` gets
  shadowed by the system `sys.color.brand` (bright blue) when the HAR is consumed by another app.
- `attributeModifier` outranks chained attribute calls — override preset values in the Spec, not after the call.
- Verified on a real device (nova 14 Pro, HarmonyOS 7.0.0 / API 26) and used in production by the
  "五年之约" app, which cut 85 hard-coded colour literals to 4.

## License

MIT
