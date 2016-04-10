#!/usr/bin/env bash
# Build shadow phase 3 for LFS 7.9.  Shadow passwords.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=shadow-4.2.1
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

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /' {} \;

sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
	-e 's@/var/spool/mail@/var/mail@' etc/login.defs

sed -i 's/1000/999/' etc/useradd

./configure --sysconfdir=/etc --with-group-name-max-length=32
make
make install

mv -v /usr/bin/passwd /bin

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


