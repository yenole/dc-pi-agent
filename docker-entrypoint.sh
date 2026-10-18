#!/bin/sh
set -eu

# 默认启动全局安装的 pi-web-ui；传入参数时仍交给 Pi CLI，便于执行 --help 等命令。
if [ "$#" -eq 0 ]; then
  exec pi-web-ui --no-browser
fi

exec pi "$@"
