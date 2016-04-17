#!/usr/bin/env bash
# Build tar phase 3 for LFS 7.9.
# The classic tape archive program (directory serializer).

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=tar-1.28
archive=$src/${pkg}.tar.xz

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot environment."
	exit 1
fi

echo "$S: Building $pkg phase 3 (chroot)."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

FORCE_UNSAFE_CONFIGURE=1 \
./configure --prefix=/usr \
	--bindir=/bin
make
make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.28

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


