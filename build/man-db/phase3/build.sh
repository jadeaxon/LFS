#!/usr/bin/env bash
# Build man-db phase 3 for LFS 7.9.
# Man pages database.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=man-db-2.7.5
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
	--docdir=/usr/share/doc/man-db-2.7.5 \
	--sysconfdir=/etc \
	--disable-setuid \
	--with-browser=/usr/bin/lynx \
	--with-vgrind=/usr/bin/vgrind \
	--with-grap=/usr/bin/grap
make
make check
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


