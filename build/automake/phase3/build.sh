#!/usr/bin/env bash
# Build automake phase 3 for LFS 7.9.
# Generates makefiles for use with autoconf.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=automake-1.15
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

sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15
make
sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
make -j4 check
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


