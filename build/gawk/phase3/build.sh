#!/usr/bin/env bash
# Build gawk phase 3 for LFS 7.9.
# Field-based parsing tool.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=gawk-4.1.3
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

./configure --prefix=/usr
make
make check
make install

mkdir -v /usr/share/doc/gawk-4.1.3
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.3

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


