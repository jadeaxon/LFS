#!/usr/bin/env bash
# Build eudev phase 3 for LFS 7.9.
# Extended userland devices.  Dynamically create device nodes.
# You make rules to set up the devices under /dev at boot.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=eudev-3.1.5
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

# Fix a test script.
sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl

# Prevent hardcoding of /tools.
cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF

./configure --prefix=/usr \
	--bindir=/sbin \
	--sbindir=/sbin \
	--libdir=/usr/lib \
	--sysconfdir=/etc \
	--libexecdir=/lib \
	--with-rootprefix= \
	--with-rootlibdir=/lib \
	--enable-manpages \
	--disable-static \
	--config-cache
LIBRARY_PATH=/tools/lib make
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make LD_LIBRARY_PATH=/tools/lib check
make LD_LIBRARY_PATH=/tools/lib install

# Some udev rules to support LFS.
tar -xvf $src/udev-lfs-20140408.tar.bz2
make -f udev-lfs-20140408/Makefile.lfs install

# Update the hardware database.
LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


