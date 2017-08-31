#!/bin/bash

if [[ ${HOST} =~ .*darwin.* ]]; then
  WITHOUT_X=--without-x
fi

CPPFLAGS=-I${PREFIX}/includee     \
LDFLAGS=-L${PREFIX}/lib           \
  ./configure --prefix=${PREFIX}  \
              --with-launchd-agent-dir=${PREFIX} \
              --disable-systemd   \
              --disable-selinux   \
              --disable-xml-docs  \
              ${WITHOUT_X}
make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

if [[ ${HOST} =~ .*darwin.* ]]; then
  cp ${RECIPE_DIR}/post-link.sh.Darwin "${PREFIX}/bin/.dbus-post-link.sh"
fi
