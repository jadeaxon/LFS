#!/usr/bin/env bash

# Run this from extracted tarball dir, not the build- dir.

if [ ! -f glibc*.patch ]; then
	cp ../glibc*.patch .
	patch -p1 glibc*.patch
fi

if [ ! -r /usr/include/rpc/types.h ]; then
	su -c 'mkdir -pv /usr/include/rpc'
	su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc'
fi

sed -e '/ia32/s/^/1:/' \
	-e '/SSE2/s/^1://' \
	-i sysdeps/i386/i686/multiarch/mempcpy_chk.S

