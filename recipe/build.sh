#!/bin/bash

CPPFLAGS=-I${PREFIX}/include \
LDFLAGS=-L${PREFIX}/lib      \
  ./configure --prefix=${PREFIX} \
              --with-launchd-agent-dir=${PREFIX} \
              --disable-systemd \
              --disable-selinux \
              --disable-xml-docs
make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

if [[ ${HOST} =~ .*darwin.* ]]; then
  cp ${RECIPE_DIR}/post-link.sh.Darwin "${PREFIX}/bin/.dbus-post-link.sh"
fi
