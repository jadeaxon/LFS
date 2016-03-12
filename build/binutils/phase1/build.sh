#!/usr/bin/env bash
# Build binutils phase 1 for LFS 7.9.

set -e

S=$(basename $0)
pkg=binutils-2.26
archive=$LFS/sources/binutils-2.26.tar.bz2

echo "$S: Building $pkg phase 1 for ${LFS_TGT}."

rm -rf $pkg
tar xavf $archive
echo "$S: Extracting archive $archive."
cd $pkg
mkdir build
cd build


# --prefix -- where to install binutils
# --with-sysroot -- look here for system libs during xcompile, not /.
# --with-lib-path -- linker should look for libs here
# --target -- target arch; since slightly different from host arch, xcompile will happen.
# --disable-nls -- no internationalization
# --disable-werror -- don't blow up on compile errors
echo "$S: Configuring $pkg phase 1 for ${LFS_TGT}."
../configure --prefix=/tools \
	--with-sysroot=$LFS \
	--with-lib-path=/tools/lib \
	--target=$LFS_TGT \
	--disable-nls \
	--disable-werror

make

# Create necessary symlink for 64-bit arch.
case $(uname -m) in
	 x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac

make install



