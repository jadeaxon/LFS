#!/usr/bin/env bash
# Build iproute2 phase 3 for LFS 7.9.
# IPv4 networking.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=iproute2-4.4.0
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

sed -i /ARPD/d Makefile
sed -i 's/arpd.8//' man/man8/Makefile
rm -v doc/arpd.sgml


make
make DOCDIR=/usr/share/doc/iproute2-4.4.0 install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


