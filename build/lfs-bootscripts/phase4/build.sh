#!/usr/bin/env bash
# Build lfs-bootscripts phase 4 for LFS 7.9.
# Boot scripts for LFS.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=lfs-bootscripts-20150222
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

make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


