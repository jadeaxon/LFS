#!/usr/bin/env bash
# Build xz phase 3 for LFS 7.9.
# Compression.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=xz-5.2.2
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

sed -e '/mf\.buffer = NULL/a next->coder->mf.size = 0;' \
	-i src/liblzma/lz/lz_encoder.c

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/xz-5.2.2
make
make check
make install

mv -v /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


