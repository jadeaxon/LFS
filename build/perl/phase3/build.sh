#!/usr/bin/env bash
# Build perl phase 3 for LFS 7.9.
# The pathologically eclectic rubbish lister.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=perl-5.22.1
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

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des -Dprefix=/usr \
	-Dvendorprefix=/usr \
	-Dman1dir=/usr/share/man/man1 \
	-Dman3dir=/usr/share/man/man3 \
	-Dpager="/usr/bin/less -isR" \
	-Duseshrplib
make
make -k test
make install
unset BUILD_ZLIB BUILD_BZIP2

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


