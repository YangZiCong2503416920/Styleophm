<#
.SYNOPSIS
    构建并发布 styleophm 到 ohpm 公共仓。

.DESCRIPTION
    依赖三样东西（见 docs/publishing.md）：
      1. 环境变量 OHPM_PUBLISH_ID（ohpm 个人中心的发布 ID）
      2. 私钥：%USERPROFILE%\.ohpm\keys\styleophm_rsa（必须带口令）
      3. 公钥已上传到 ohpm 控制台
    脚本负责构建 HAR 并调用 ohpm publish；ohpm 会交互式询问私钥口令。

.EXAMPLE
    $env:OHPM_PUBLISH_ID = 'xxxxx'
    pwsh scripts/publish.ps1
#>
[CmdletBinding()]
param(
    [string]$PublishId = $env:OHPM_PUBLISH_ID,
    [string]$KeyPath = (Join-Path $env:USERPROFILE '.ohpm\keys\styleophm_rsa'),
    [string]$Tag = 'latest',
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$har = Join-Path $root 'styleophm\build\default\outputs\default\styleophm.har'

if ([string]::IsNullOrWhiteSpace($PublishId)) {
    throw '缺少 publish_id：先设置 $env:OHPM_PUBLISH_ID，或传 -PublishId（见 docs/publishing.md）'
}
if (-not (Test-Path $KeyPath)) {
    throw "找不到私钥：$KeyPath（用 ssh-keygen -t rsa -b 4096 -m PEM 生成，并设置口令）"
}

# 版本一致性先过一遍守卫
Push-Location $root
try {
    node scripts/guard.mjs
    if ($LASTEXITCODE -ne 0) { throw 'guard 未通过，先修问题再发布' }

    if (-not $SkipBuild) {
        Write-Host '[1/2] 构建 release HAR…' -ForegroundColor Cyan
        devecocli build --modules styleophm@default --build-mode release
        if ($LASTEXITCODE -ne 0) { throw '构建失败' }
    }

    if (-not (Test-Path $har)) { throw "找不到产物：$har" }

    $version = (Get-Content (Join-Path $root 'styleophm\oh-package.json5') | Select-String '"version"').Line
    Write-Host "[2/2] 发布 $version（tag=$Tag）…" -ForegroundColor Cyan
    ohpm publish $har --readme (Join-Path $root 'README.md') --publish_id $PublishId --key_path $KeyPath --tag $Tag
    if ($LASTEXITCODE -ne 0) { throw 'ohpm publish 失败，见上方报错（对照 docs/publishing.md 的报错表）' }
} finally {
    Pop-Location
}

Write-Host '发布完成。验证：ohpm info styleophm' -ForegroundColor Green
