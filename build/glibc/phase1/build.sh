#!/usr/bin/env bash
# Build glibc phase 1 for LFS 7.9.

set -e


S=$(basename $0)
D=$(pwd)
src=/mnt/LFS/sources
pkg=glibc-2.23
archive=$src/${pkg}.tar.*

echo "$S: Building $pkg phase 1 for ${LFS_TGT}."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

echo "$S: Patching ${pkg}."
patch -p1 < $src/${pkg}*.patch

mkdir build
cd build

echo "$S: Configuring $pkg phase 1 for ${LFS_TGT}."
../configure \
	--prefix=/tools \
	--host=$LFS_TGT \
	--build=$(../scripts/config.guess) \
	--disable-profile \
	--enable-kernel=2.6.32 \
	--enable-obsolete-rpc \
	--with-headers=/tools/include \
	libc_cv_forced_unwind=yes \
	libc_cv_ctors_header=yes \
	libc_cv_c_cleanup=yes


make

# LFS 7.7
# Create necessary symlink for 64-bit arch.
# case $(uname -m) in
	 # x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
# esac

make install

cd $D
rm -rf $pkg
echo "$S: Total victory!"





