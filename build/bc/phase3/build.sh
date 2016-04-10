#!/usr/bin/env bash
# Build bc phase 3 for LFS 7.9.
# bc is a command-line calculator.  Used to do floating point math in Bash scripts.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=bc-1.06.95
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
patch -Np1 -i $src/bc-1.06.95-memory_leak-1.patch

./configure --prefix=/usr \
	--with-readline \
	--mandir=/usr/share/man \
	--infodir=/usr/share/info
make
echo "quit" | ./bc/bc -l Test/checklib.b # Test.
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


