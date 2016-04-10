#!/usr/bin/env bash
# Build autoconf phase 3 for LFS 7.9.
# Produces shell scripts that can configure source code.
# This is probably what is used to create the ./configure script which creates the makefile in many
# projects.
# The configure scripts generated have no runtime dependence on the autoconf pkg.
# Helps create source pkgs that will build in multiple Unix-like environments.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=autoconf-2.69
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

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


