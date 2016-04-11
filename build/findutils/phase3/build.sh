#!/usr/bin/env bash
# Build findutils phase 3 for LFS 7.9.
# Utilities for traversing file system trees.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=findutils-4.6.0
archive=$src/${pkg}.tar.gz

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot environment."
	exit 1
fi

echo "$S: Building $pkg phase 3 (chroot)."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make check
make install

mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


