"""
用 ConPTY 跑 ohpm publish，并自动回答私钥口令。

为什么需要这个：ohpm 读取私钥口令时走 readline raw 模式（stdin.setRawMode），
在没有真实终端的 CI / 脚本里会直接崩（`s.stdin.setRawMode is not a function`）。
`key_passphrase` 也只能配置加密后的值；用 pywinpty 起一个伪终端最省事。

依赖：pip install pywinpty
用法：python scripts/publish_pty.py [--har <path>] [--pass-file <path>]

口令文件默认 %USERPROFILE%\\.ohpm\\keys\\styleophm_pass.txt（只有口令本身，一行）。
"""

import argparse
import os
import re
import sys
import time

import winpty

DEFAULT_PASS = os.path.join(os.environ.get("USERPROFILE", "~"), ".ohpm", "keys", "styleophm_pass.txt")
DEFAULT_HAR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "styleophm", "build", "default", "outputs", "default", "styleophm.har",
)
OHPM = os.path.join(
    os.environ.get("DEVECO_HOME", r"D:\Program Files\Huawei\DevEco Studio"),
    "tools", "ohpm", "bin", "ohpm.bat",
)


def main() -> int:
    parser = argparse.ArgumentParser(description="publish styleophm through a pseudo terminal")
    parser.add_argument("--har", default=DEFAULT_HAR)
    parser.add_argument("--pass-file", default=DEFAULT_PASS)
    parser.add_argument("--timeout", type=int, default=600)
    args = parser.parse_args()

    passphrase = open(args.pass_file, encoding="utf-8").read().strip()
    publish_cmd = '"{}" publish "{}"'.format(OHPM, args.har)

    proc = winpty.PtyProcess.spawn("cmd.exe", cwd=os.path.dirname(args.har))
    time.sleep(1.0)
    proc.write(publish_cmd + "\r")

    buf = ""
    attempts = 0
    deadline = time.time() + args.timeout
    tail_text = ""

    while time.time() < deadline:
        try:
            chunk = proc.read(4096)
        except (EOFError, OSError):
            break
        if chunk:
            buf += chunk
            tail_text = buf[-400:].lower()
            if re.search(r"passphrase of the private key", tail_text) and attempts < 3:
                time.sleep(0.4)
                for ch in passphrase:      # 逐字符输入，避免 raw 模式丢字节
                    proc.write(ch)
                    time.sleep(0.02)
                proc.write("\r")
                attempts += 1
                buf = ""
        else:
            if not proc.isalive():
                break
            time.sleep(0.2)

    code = None
    try:
        code = proc.wait(timeout=30)
    except Exception:
        pass

    print("\n=== ohpm publish finished, exit code:", code, "===")
    print("look for 'under review' (submitted) or an error code above.")
    return 0 if code == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
