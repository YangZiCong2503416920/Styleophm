# 发布到 ohpm

ohpm（OpenHarmony 包管理）就是鸿蒙侧的 npm：`ohpm install <name>` 从 `https://ohpm.openharmony.cn/ohpm/` 拉包。发布需要一个账号体系外的凭证：**publish_id + 私钥（带非空口令）+ 已上传的公钥**。

本机已经准备好的部分：

| 物料 | 路径 |
| --- | --- |
| RSA 私钥（PEM，已用口令加密） | `%USERPROFILE%\.ohpm\keys\styleophm_rsa` |
| 公钥 | `%USERPROFILE%\.ohpm\keys\styleophm_rsa.pub` |
| 私钥口令 | `%USERPROFILE%\.ohpm\keys\styleophm_pass.txt`（仅本机，勿入库） |
| 发布脚本 | `scripts/publish.ps1` |

## 只能由账号持有人完成的两步

1. 打开 <https://ohpm.openharmony.cn/#/cn/personalCenter/myPackage>，用华为账号登录 → 个人中心 → **发布 ID（publish_id）**，复制那一串 ID。
2. 同一个页面里的 **公钥** 一栏，粘贴 `%USERPROFILE%\.ohpm\keys\styleophm_rsa.pub` 的内容并保存（公钥长这样）：

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+gNPLNVtqJLl76vpe5fUa8W6XMf2cJceEEKIz4RxAWoZPS3TOM3QWXpKZAhRrspUgS4OAkJfYPFV9yf6Ny+FbdcWjX4h3rEZkSJxV60DkDHzZazvcetQZkExSMRc2Smz+V11cLQnADX92n87/n4P7KOA8x5Zr+a5nTqjEFQHeHUemROQ87HvZaZGNcXfGJU+q00awbCtHAlwnj9HrBLy+VTzXphs6N+/WCJF1rToihADWEvcd7x70+fI59VZGGv4zqO1oYQ5A8jkd7VyKTukWKKuuPtDv4QJ8qwyicBn4m57+108yqCXMWgejAuClbZ9kcg/sCdTgCfmdBnxh7thqv+t4a8Jpkrd5lNvlxP6sabfLynyICeW/kLJhMbVopTyUGTstJfEvfOY92OLDWphVgBH8T95utUjaIPFkRXyCEC8I7wZy0h9NOTe48PfZhZgTz9P7UtRFPRKbHQ6UGbfZ7T1ltq8Xu+Mtv7W5p2DTXxwE3GF48j71TsYrJNxYy5f4vghU9iUEyebOrHf5oUbgSbz8RN1WX6sJnlKYwuTej43oM/KgD+o+m9pndNxlQv21jUHHAWN38ZG5MXpKLUbWHTg0gwg4DB434iZZjTQfylo0o6zt01abRjFoiKlIaQJGm6wDgErwqRRI86WeGBUh6owu19XzyZTATe8BknLEmw== styleophm-publish
```

> 公钥可以随便公开；私钥和口令不要提交、不要贴到聊天里。想换钥匙就重新 `ssh-keygen -t rsa -b 4096 -m PEM -f <新路径>` 并在控制台上替换公钥。

## 然后一条命令

```powershell
$env:OHPM_PUBLISH_ID = '<你的 publish_id>'
pwsh scripts/publish.ps1            # 构建 HAR + 带上 README 发布
```

脚本会：`devecocli build --modules styleophm@default --build-mode release` → 取 `styleophm.har` → `ohpm publish`。执行时 ohpm 会交互式问私钥口令（就是 `styleophm_pass.txt` 里那串 28 位）。

也可以手动跑：

```powershell
ohpm publish .\styleophm\build\default\outputs\default\styleophm.har `
  --readme .\README.md `
  --publish_id <你的 publish_id> `
  --key_path "$env:USERPROFILE\.ohpm\keys\styleophm_rsa"
```

发布成功后：

```bash
ohpm install styleophm
ohpm view styleophm          # 看版本、依赖、README
```

## 常见报错对照

| 报错 | 原因 |
| --- | --- |
| `00609002 Key Path Is Empty Or NotFound` | 没传 `--key_path`，或 `.ohpmrc` 里没有 `key_path` |
| `00609007 Not Support PrivateKey` | 私钥没有口令；ohpm 强制要求加密私钥 |
| `0060900x ... publish_id` 相关 | 控制台没复制 publish_id，或公钥没上传/不匹配 |
| `the har file contains source code` | 只是警告：HAR 会带上 `src/main/ets` 源码与 `.d.ets`，HAR 的常规形态 |
| 版本已存在 | 同一个 `version` 不能重复发布，改 `styleophm/oh-package.json5` 的 `version` 后重新构建 |

## 版本策略

- 语义化版本；`scripts/guard.mjs` 会校验 `styleophm/oh-package.json5`、`entry/oh-package.json5`、`AppScope/app.json5`、`CHANGELOG.md` 四处一致；
- 发版流程：改版本 → 更新 CHANGELOG → `node scripts/guard.mjs` → `devecocli build --build-mode release` → `git commit` → `git tag -a vX.Y.Z` → `git push --follow-tags` → `gh release create vX.Y.Z styleophm.har` → `pwsh scripts/publish.ps1`。
