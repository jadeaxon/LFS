#!/usr/bin/env bash
# Build util-linux phase 3.
# Various Linux utilities.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=util-linux-2.27.1
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

# FHS compliance.
mkdir -pv /var/lib/hwclock

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
	--docdir=/usr/share/doc/util-linux-2.27.1 \
	--disable-chfn-chsh \
	--disable-login \
	--disable-nologin \
	--disable-su \
	--disable-setpriv \
	--disable-runuser \
	--disable-pylibmount \
	--disable-static \
	--without-python \
	--without-systemd \
	--without-systemdsystemunitdir
make
# WARNING: Running these tests as root will destroy your system.
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make -k check"
make install

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


