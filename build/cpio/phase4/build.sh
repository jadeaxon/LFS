#!/usr/bin/env bash
# Build cpio phase 4 for LFS 7.9.  Technically BLFS now.
# Archive tool that creates the form necessary for initramfs images.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=cpio-2.12
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

./configure --prefix=/usr \
	--bindir=/bin \
	--enable-mt   \
	--with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi
make check

make install &&
install -v -m755 -d /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/html/* /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/cpio.{html,txt} /usr/share/doc/cpio-2.12

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


