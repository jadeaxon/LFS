#!/usr/bin/env bash
# Build libtool phase 3 for LFS 7.9.
# Helps in using shared libraries.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=libtool-2.4.6
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
# make check
# These tests fail but are known to fail:
# 123: standalone.at:31   compiling softlinked libltdl
# libtoolize
# 124: standalone.at:46   compiling copied libltdl
# libtoolize
# 125: standalone.at:61   installable libltdl
# libtoolize
# 126: standalone.at:79   linking libltdl without autotools
# libtoolize
# 130: subproject.at:109  linking libltdl without autotools
# libtoolize
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


