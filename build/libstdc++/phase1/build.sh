#!/usr/bin/env bash
# Build libstdc++ phase 1 for LFS 7.9.

# PRE: gcc has been built and installed to /tools.

shopt -s nullglob
set -e

S=$(basename $0)
D=$(pwd)
src=/mnt/LFS/sources

# NOTE: libstdc++ is also built from the gcc sources.
pkg=gcc-5.3.0
archive=( $src/${pkg}.tar.* ) # Expand glob into an array.
archive=${archive[0]}

echo "$S: Building $pkg (libstdc++) phase 1 for ${LFS_TGT}."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

patch=( $src/${pkg}*.patch )
patch=${patch[0]}
if [ "$patch" ]; then
	echo "$S: Patching ${pkg} with ${patch}."
	patch -p1 < $patch
fi

mkdir build
cd build

echo "$S: Configuring $pkg (libstdc++) phase 1 for ${LFS_TGT}."
../libstdc++-v3/configure \
	--host=$LFS_TGT \
	--prefix=/tools \
	--disable-multilib \
	--disable-nls \
	--disable-libstdcxx-threads \
	--disable-libstdcxx-pch \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/5.3.0

make
make install

cd $D
rm -rf $pkg
echo "$S: Total victory!"


