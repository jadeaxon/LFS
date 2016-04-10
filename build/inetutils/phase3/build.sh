#!/usr/bin/env bash
# Build inetutils phase 3 for LFS 7.9.
# Internet utilities like ping and traceroute.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=inetutils-1.9.4
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
	--localstatedir=/var \
	--disable-logger \
	--disable-whois \
	--disable-rcp \
	--disable-rexec \
	--disable-rlogin \
	--disable-rsh \
	--disable-servers
make
make check
make install

mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


