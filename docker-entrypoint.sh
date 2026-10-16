#!/bin/sh
set -eu

PI_SETTINGS="${PI_AGENT_DIR:-${HOME}/.pi/agent}/settings.json"

# Pi 保存已安装包的来源到 settings.json 的 packages 数组。
if ! { [ -f "$PI_SETTINGS" ] && jq -e '
  (.packages // []) | any(
    . == "npm:pi-web-ui" or
    (type == "string" and startswith("npm:pi-web-ui@"))
  )
' "$PI_SETTINGS" >/dev/null 2>&1; }; then
  echo "[pi-agent] pi-web-ui 未安装，正在安装..."
  pi install npm:pi-web-ui
else
  echo "[pi-agent] pi-web-ui 已安装，跳过安装。"
fi

# 将完整斜杠命令作为 Pi 的初始输入；webui 扩展要求 start 动作后再接选项。
if [ "$#" -eq 0 ]; then
  exec pi "/webui start --no-browser"
fi

exec pi "$@"
