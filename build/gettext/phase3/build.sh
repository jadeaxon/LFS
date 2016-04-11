#!/usr/bin/env bash
# Build gettext phase 3 for LFS 7.9.
# Tools for internationalization and localization.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=gettext-0.19.7
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

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/gettext-0.19.7
make
make check
make install

chmod -v 0755 /usr/lib/preloadable_libintl.so

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


