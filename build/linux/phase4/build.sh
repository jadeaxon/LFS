#!/usr/bin/env bash
# Build the Linux kernel phase 4 for LFS 7.9.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources # Note that this is no longer /mnt/LFS/sources
pkg=linux-4.4.2
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

make mrproper

# NOTE: I manually did the rest of the step.

# cd ..
# rm -rf $pkg
echo "$S: Total victory!"




