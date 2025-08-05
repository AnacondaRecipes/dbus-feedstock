#!/bin/bash
set -euo pipefail

meson setup build \
  ${MESON_ARGS:-} \
  --prefix="${PREFIX}" \
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

# Ensure the soname symlink exists
if [[ -f "${PREFIX}/lib/libdbus-1.so.3.38.3" ]]; then
    cd "${PREFIX}/lib"
    ln -sf libdbus-1.so.3.38.3 libdbus-1.so.3
    echo "Created symlink: libdbus-1.so.3 -> libdbus-1.so.3.38.3"
elif [[ -f "${PREFIX}/lib64/libdbus-1.so.3.38.3" ]]; then
    cd "${PREFIX}/lib64"
    ln -sf libdbus-1.so.3.38.3 libdbus-1.so.3
    echo "Created symlink in lib64: libdbus-1.so.3 -> libdbus-1.so.3.38.3"
fi

# Verify library installation
find "${PREFIX}" -name "*libdbus*" -type f | sort
find "${PREFIX}" -name "*libdbus*" -type l | sort
