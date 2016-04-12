#!/usr/bin/env bash
# Build kmod phase 3 for LFS 7.9.
# Support for loading kernel modules.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=kmod-22
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
	--bindir=/bin \
	--sysconfdir=/etc \
	--with-rootlibdir=/lib \
	--with-xz \
	--with-zlib
make
make install

for target in depmod insmod lsmod modinfo modprobe rmmod; do
	ln -sv ../bin/kmod /sbin/$target
done
ln -sv kmod /bin/lsmod

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


