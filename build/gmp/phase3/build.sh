#!/usr/bin/env bash
# Build GMP phase 3 for LFS 7.9.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=gmp-6.1.0
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

./configure --prefix=/usr \
	--enable-cxx \
	--disable-static \
	--docdir=/usr/share/doc/gmp-6.1.0
make
make html
make check 2>&1 | tee gmp-check-log
passed=$(awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log)
if (( passed == 190 )); then
	make install
	make install-html
else
	echo "$S: ERROR: All tests did not pass.  Aborting build!"
	exit 1
fi

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


