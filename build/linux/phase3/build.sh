#!/usr/bin/env bash
# Build Linux headers phase 3 for LFS 7.9.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources # Note that this is no longer /mnt/LFS/sources
pkg=linux-4.4.2
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

make mrproper
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
# Instead of /tools/include (on host), we now install to /usr/include on new system.
cp -rv dest/include/* /usr/include

cd ..
rm -rf $pkg
echo "$S: Total victory!"




