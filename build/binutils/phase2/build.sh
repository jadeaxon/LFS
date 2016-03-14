#!/usr/bin/env bash
# Build binutils phase 2 for LFS 7.9.

set -e
shopt -s nullglob

S=$(basename $0)
D=$(pwd)

src=/mnt/LFS/sources
pkg=binutils-2.26
archive=( $src/${pkg}.tar.* )
archive=${archive[0]}

echo "$S: Building $pkg phase 2 for ${LFS_TGT}."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

echo "$S: Patching ${pkg}."
patch -p1 < $src/binutils*.patch

mkdir build
cd build

# We are cross-compiling with a compatible cross-compiler.  This is the gcc compiler we build
# previously in phase 1.  The binaries are compatible with the host system, but not intended for it.
# The reason this is phase 2 is because we are now using the compiler we built instead of the
# host's.
echo "$S: Configuring $pkg phase 2 for ${LFS_TGT}."
CC=$LFS_TGT-gcc \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure \
	--prefix=/tools \
	--disable-nls \
	--disable-werror \
	--with-lib-path=/tools/lib \
	--with-sysroot

make
make install

# Prepare for the readjusting phase in the next chapter (?).
echo "Rebuilding ld."
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

cd $D
rm -rf $pkg
echo "$S: Total victory!"


