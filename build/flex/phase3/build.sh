#!/usr/bin/env bash
# Build flex  phase 3 for LFS 7.9.
# Flex and Bison are used together as compiler-compilers.  Flex supercedes lex.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=flex-2.6.0
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

./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.0
make
make check
make install

ln -sv flex /usr/bin/lex

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


