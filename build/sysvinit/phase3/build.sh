#!/usr/bin/env bash
# Build sysvinit phase 3 for LFS 7.9.
# The System V style init programs: init, reboot, halt, shutdown, telinit, etc.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=sysvinit-2.88dsf
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

echo "$S: Patching ${pkg}."
patch -Np1 -i $src/sysvinit-2.88dsf-consolidated-1.patch

make -C src
make -C src install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


