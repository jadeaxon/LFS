#!/usr/bin/env bash
# Build grub phase 3 for LFS 7.9.
# GRUB: Grand Unified Bootloader.
# Section 8.4 will tell you how to use GRUB to make your system bootable.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=grub-2.02~beta2
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
	--sbindir=/sbin \
	--sysconfdir=/etc \
	--disable-grub-emu-usb \
	--disable-efiemu \
	--disable-werror
make
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


