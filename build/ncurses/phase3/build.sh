#!/usr/bin/env bash
# Build ncurses phase 3 for LFS 7.9.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=ncurses-6.0
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

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

./configure --prefix=/usr \
	--mandir=/usr/share/man \
	--with-shared \
	--without-debug \
	--without-normal \
	--enable-pc-files \
	--enable-widec
make
make install

mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so

echo "$S: Enabling support for older apps."
# Trick older apps into using wide character sets.
for lib in ncurses form panel menu ; do
	rm -vf /usr/lib/lib${lib}.so
	echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
	ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
done

# Make stuff looking for 'curses' use 'ncurses'.
rm -vf /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so /usr/lib/libcurses.so

echo "$S: Installing documentation for ${pkg}."
mkdir -v /usr/share/doc/ncurses-6.0
cp -v -R doc/* /usr/share/doc/ncurses-6.0

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"





