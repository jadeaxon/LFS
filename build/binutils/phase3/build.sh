#!/usr/bin/env bash
# Build file phase 3 for LFS 7.9.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=binutils-2.26
archive=$src/${pkg}.tar.bz2

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot environment."
	exit 1
fi

echo "$S: Building $pkg phase 3 (chroot)."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

echo "$S: Applying patch."
patch -Np1 -i $src/binutils-2.26-upstream_fix-2.patch

mkdir -v build
cd build

../configure --prefix=/usr \
	--enable-shared \
	--disable-werror
make tooldir=/usr

# FAIL: Link with zlib-gabi compressed debug output
# https://sourceware.org/bugzilla/show_bug.cgi?id=17618
# This appears to be a known bug in the x86_64 tests for binutils 2.26.
make check # Crucial: Do not skip.
make tooldir=/usr install

cd ..
cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


