#!/usr/bin/env bash
# Build XML::Parser Perl model phase 3 for LFS 7.9.
# This is a Perl interface to Expat (which we built earlier).

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=XML-Parser-2.44
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

perl Makefile.PL
make
make test
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


