#!/bin/bash
set -euo pipefail

meson setup build \
  ${MESON_ARGS} \
  --wrap-mode=nodownload \
  -Dsystemd=disabled \
  -Dselinux=disabled \
  -Dxml_docs=disabled \
  -Dlaunchd_agent_dir="${PREFIX}"

meson compile -C build
if [[ "${target_platform}" != osx-* ]]; then
   meson test -C build --print-errorlogs
fi
meson install -C build
