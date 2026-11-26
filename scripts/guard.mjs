#!/usr/bin/env node
/**
 * Styleophm 静态守卫（零依赖，本地与 CI 共用）。
 *
 * 它检查的是「这个库自己的家规」，而不是语法（语法交给 ArkTS 编译器）：
 *  1. 必需文件齐全（LICENSE / README / CHANGELOG / 模块清单 / 深浅色资源）；
 *  2. base 与 dark 两套颜色表键名/格式一致；
 *  3. StylexColor 里的 `$r('app.color.*')` 全部有对应资源，反之资源也必须被暴露；
 *  4. 预设层零裸值：PactStyles.ets 不允许出现十六进制色值和裸数值（PactMetric 内部除外）；
 *  5. 公共符号必须从 Index.ets 导出；
 *  6. 禁止 `any` / `@ts-ignore` / `eslint-disable` 这类绕过严格模式的写法；
 *  7. 版本号三处一致（库、示例、AppScope）。
 */

import { readFileSync, existsSync } from 'node:fs';
import { dirname, join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const ETS_DIR = join(ROOT, 'styleophm', 'src', 'main', 'ets');

const results = [];
let failed = 0;

function record(passed, name, detail) {
  results.push({ passed, name, detail });
  if (!passed) {
    failed += 1;
  }
}

function read(relPath) {
  return readFileSync(join(ROOT, relPath), 'utf8');
}

function stripComments(source) {
  return source.replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/[^\n]*/g, '');
}

// -----------------------------------------------------------------------------
// 1. 必需文件
// -----------------------------------------------------------------------------
const REQUIRED = [
  'LICENSE',
  'README.md',
  'CHANGELOG.md',
  'oh-package.json5',
  'build-profile.json5',
  'styleophm/Index.ets',
  'styleophm/oh-package.json5',
  'styleophm/src/main/module.json5',
  'styleophm/src/main/resources/base/element/color.json',
  'styleophm/src/main/resources/dark/element/color.json',
  'entry/src/main/module.json5',
  'entry/src/main/ets/pages/Index.ets',
  'scripts/guard.mjs'
];
const missing = REQUIRED.filter((p) => !existsSync(join(ROOT, p)));
record(missing.length === 0, 'required files', missing.length === 0 ? `${REQUIRED.length} files present`
  : `missing: ${missing.join(', ')}`);

// -----------------------------------------------------------------------------
// 2. ohpm 发布物料：README / CHANGELOG / LICENSE 必须在库模块内（HAR 只打包模块目录）
// -----------------------------------------------------------------------------
const PACKAGE_DOCS = ['styleophm/README.md', 'styleophm/CHANGELOG.md', 'styleophm/LICENSE'];
const missingDocs = PACKAGE_DOCS.filter((p) => !existsSync(join(ROOT, p)));
record(missingDocs.length === 0, 'package docs in module',
  missingDocs.length === 0 ? `${PACKAGE_DOCS.length} files shipped inside styleophm/`
    : `missing: ${missingDocs.join(', ')}`);

const mirrors = [
  ['LICENSE', 'styleophm/LICENSE'],
  ['CHANGELOG.md', 'styleophm/CHANGELOG.md']
];
const drifted = mirrors.filter(([rootFile, moduleFile]) =>
  existsSync(join(ROOT, rootFile)) && existsSync(join(ROOT, moduleFile)) &&
  read(rootFile).replace(/\r\n/g, '\n') !== read(moduleFile).replace(/\r\n/g, '\n'));
record(drifted.length === 0, 'package docs in sync',
  drifted.length === 0 ? 'LICENSE / CHANGELOG copies match the repo root'
    : `drifted: ${drifted.map(([a, b]) => `${a} -> ${b}`).join(', ')}`);

// -----------------------------------------------------------------------------
// 3. 深浅色颜色表
// -----------------------------------------------------------------------------
const baseColors = JSON.parse(read('styleophm/src/main/resources/base/element/color.json')).color;
const darkColors = JSON.parse(read('styleophm/src/main/resources/dark/element/color.json')).color;

const baseNames = baseColors.map((c) => c.name).sort();
const darkNames = darkColors.map((c) => c.name).sort();
record(baseNames.join(',') === darkNames.join(','), 'dark palette parity',
  `${baseNames.length} base / ${darkNames.length} dark keys`);

const HEX = /^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$/;
const badHex = [...baseColors, ...darkColors].filter((c) => !HEX.test(c.value));
record(badHex.length === 0, 'colour value format',
  badHex.length === 0 ? 'all values are #RRGGBB(AA)' : `bad: ${badHex.map((c) => `${c.name}=${c.value}`).join(', ')}`);

const baseSet = new Set(baseNames);
const darkSet = new Set(darkNames);
const onlyBase = [...baseSet].filter((n) => !darkSet.has(n));
const onlyDark = [...darkSet].filter((n) => !baseSet.has(n));
record(onlyBase.length === 0 && onlyDark.length === 0, 'palette key symmetry',
  onlyBase.length + onlyDark.length === 0 ? 'base and dark declare the same keys'
    : `base-only: ${onlyBase.join(',')} dark-only: ${onlyDark.join(',')}`);

// -----------------------------------------------------------------------------
// 3. StylexColor <-> color.json
// -----------------------------------------------------------------------------
const tokensSource = read('styleophm/src/main/ets/StylexTokens.ets');
const refs = [...tokensSource.matchAll(/\$r\('app\.color\.([a-z0-9_]+)'\)/g)].map((m) => m[1]);
const unknownRefs = refs.filter((name) => !baseSet.has(name));
record(unknownRefs.length === 0, 'StylexColor resource refs',
  unknownRefs.length === 0 ? `${refs.length} refs resolved` : `unknown: ${unknownRefs.join(', ')}`);

const unreferenced = baseNames.filter((name) => !refs.includes(name));
record(unreferenced.length === 0, 'palette exposure',
  unreferenced.length === 0 ? 'every palette entry is exposed via StylexColor'
    : `not exposed: ${unreferenced.join(', ')}`);

const duplicates = refs.filter((name, i) => refs.indexOf(name) !== i);
record(duplicates.length === 0, 'StylexColor uniqueness',
  duplicates.length === 0 ? 'no duplicated resource binding' : `duplicated: ${[...new Set(duplicates)].join(', ')}`);

// -----------------------------------------------------------------------------
// 4. 预设层零裸值
// -----------------------------------------------------------------------------
const pactRaw = read('styleophm/src/main/ets/PactStyles.ets');
const pactBody = stripComments(pactRaw);
const metricBlock = /class PactMetric \{[\s\S]*?\n\}/.exec(pactBody);
record(metricBlock !== null, 'PactMetric present',
  metricBlock !== null ? 'component tier metrics declared' : 'PactMetric class not found');

const pactWithoutMetric = metricBlock === null ? pactBody : pactBody.replace(metricBlock[0], '');
const rawHex = pactWithoutMetric.match(/#[0-9A-Fa-f]{3,8}\b/g) ?? [];
record(rawHex.length === 0, 'no raw colour in presets',
  rawHex.length === 0 ? 'all preset colours come from StylexColor' : `raw: ${rawHex.join(', ')}`);

const rawNumbers = (pactWithoutMetric.match(/(?<![\w.])\d+(?:\.\d+)?(?![\w.])/g) ?? []);
record(rawNumbers.length === 0, 'no raw numbers in presets',
  rawNumbers.length === 0 ? 'all preset metrics come from tokens or PactMetric' : `raw: ${rawNumbers.join(', ')}`);

const rawStrings = [...pactRaw.matchAll(/=== '([^']*)'/g)].map((m) => m[1]);
const enumValues = [...pactRaw.matchAll(/^\s+[A-Z_]+ = '([^']*)'/gm)].map((m) => m[1]);
const strayStrings = rawStrings.filter((s) => !enumValues.includes(s));
record(strayStrings.length === 0, 'enum-only string matching',
  strayStrings.length === 0 ? 'string comparisons go through PactLayer/PactStage'
    : `stray literals: ${strayStrings.join(', ')}`);

// -----------------------------------------------------------------------------
// 5. 公共符号必须从 Index 导出
// -----------------------------------------------------------------------------
const etsFiles = ['Stylex.ets', 'StylexTokens.ets', 'PactStyles.ets'];
const declared = [];
for (const file of etsFiles) {
  const source = stripComments(read(relative(ROOT, join(ETS_DIR, file))));
  for (const match of source.matchAll(/^export (?:declare )?(?:abstract )?(class|enum|interface|type) (\w+)/gm)) {
    declared.push(match[2]);
  }
}
const indexSource = read('styleophm/Index.ets');
const notExported = declared.filter((name) => !new RegExp(`\\b${name}\\b`).test(indexSource));
record(notExported.length === 0, 'public surface exported',
  notExported.length === 0 ? `${declared.length} symbols re-exported from Index.ets` : `not exported: ${notExported.join(', ')}`);

const staleExports = [...indexSource.replace(/from\s+'[^']*'/g, 'from').matchAll(/\b(Stylex\w+|Pact\w+)\b/g)]
  .map((m) => m[1])
  .filter((name) => !declared.includes(name));
const uniqueStale = [...new Set(staleExports)];
record(uniqueStale.length === 0, 'no dangling exports',
  uniqueStale.length === 0 ? 'every re-export resolves to a declaration' : `dangling: ${uniqueStale.join(', ')}`);

// -----------------------------------------------------------------------------
// 6. 严格模式红线
// -----------------------------------------------------------------------------
const BANNED = [
  { pattern: /:\s*any\b/, label: ': any' },
  { pattern: /\bas\s+any\b/, label: 'as any' },
  { pattern: /<any>/, label: '<any>' },
  { pattern: /@ts-ignore/, label: '@ts-ignore' },
  { pattern: /@ts-nocheck/, label: '@ts-nocheck' },
  { pattern: /eslint-disable/, label: 'eslint-disable' }
];
const offenders = [];
for (const file of etsFiles) {
  const source = stripComments(read(relative(ROOT, join(ETS_DIR, file))));
  for (const rule of BANNED) {
    if (rule.pattern.test(source)) {
      offenders.push(`${file}: ${rule.label}`);
    }
  }
}
record(offenders.length === 0, 'strict-mode red lines',
  offenders.length === 0 ? 'no any / ts-ignore / eslint-disable' : offenders.join('; '));

// -----------------------------------------------------------------------------
// 7. 版本一致性
// -----------------------------------------------------------------------------
const versions = {
  library: /"version":\s*"([^"]+)"/.exec(read('styleophm/oh-package.json5'))?.[1],
  showcase: /"version":\s*"([^"]+)"/.exec(read('entry/oh-package.json5'))?.[1],
  app: /"versionName":\s*"([^"]+)"/.exec(read('AppScope/app.json5'))?.[1],
  changelog: /^##\s*\[?v?([0-9]+\.[0-9]+\.[0-9]+)/m.exec(read('CHANGELOG.md'))?.[1]
};
const versionValues = Object.values(versions);
const versionOk = versionValues.every((v) => v !== undefined) &&
  new Set(versionValues).size === 1;
record(versionOk, 'version consistency',
  versionOk ? `all ${versionValues[0]}` : JSON.stringify(versions));

// -----------------------------------------------------------------------------
// 报表
// -----------------------------------------------------------------------------
const width = Math.max(...results.map((r) => r.name.length));
for (const item of results) {
  const mark = item.passed ? 'ok  ' : 'FAIL';
  console.log(`[${mark}] ${item.name.padEnd(width)}  ${item.detail}`);
}
console.log('');
if (failed > 0) {
  console.log(`guard failed: ${failed} check(s)`);
  process.exit(1);
}
console.log(`guard passed: ${results.length} checks`);
