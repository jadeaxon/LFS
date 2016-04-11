#!/usr/bin/env bash
# Build groff phase 3 for LFS 7.9.
# Text formatting/processing programs.
# GNU roff (roff == run off, as in "run off a page", i.e., print a page).

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=groff-1.22.3
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

# Australia uses A4.
PAGE=letter ./configure --prefix=/usr
make
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


