#!/usr/bin/env bash

set -e

# TO DO: Update for LFS 7.9.

# PRE: This script is run from the directory containing it.
# PRE:
# sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

S=$(basename $0)
# gcc-5.3.0.tar.bz2
pkg=gcc-5.3.0
src=/mnt/LFS/sources
archive=$src/${pkg}.tar.bz2

echo "$S: Building $pkg phase 1 for ${LFS_TGT}."

rm -rf $pkg
tar xavf $archive
echo "$S: Extracting archive $archive."
cd $pkg
# mkdir build
# cd build

# Prepares gcc for building (in a separate dir).
# Run this script from the extracted tarball dir.
rm -rf mpfr
rm -rf gmp
rm -rf mpc

# GCC depends on these pkgs.  We'll build them in place with the compiler.
echo "$S: Including mpfr, gmp, and mpc."
tar xavf $src/mpfr-3.1.3.tar.xz
mv -v mpfr-3.1.3 mpfr
tar xavf $src/gmp-6.1.0.tar.xz
mv -v gmp-6.1.0 gmp
tar xavf $src/mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc

echo "$S: Patching mpfr."
cd mpfr
patch -p1 < $src/mpfr*.patch
cd -

echo "$S: Forcing gcc to use LFS dynamic linker from our tools/."
for file in \
	$(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
	cp -uv $file{,.orig}
	sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
		-e 's@/usr@/tools@g' $file.orig > $file
	echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
	touch $file.orig
done

# LFS 7.7
# echo "$S: Fixing a 32-bit issue."
# sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

# Run this from the $LFS/sources/gcc-build/.
# This should be an empty dir, not the one you just used to build gcc itself.
rm -rf build
echo "$S: Creating separate build dir."
pwd
mkdir -p build
cd build
echo "$S: gcc is now ready to be configured and built."

# Configure gcc.
../configure \
	--target=$LFS_TGT \
	--prefix=/tools \
	--with-glibc-version=2.11 \
	--with-sysroot=$LFS \
	--with-newlib \
	--without-headers \
	--with-local-prefix=/tools \
	--with-native-system-header-dir=/tools/include \
	--disable-nls \
	--disable-shared \
	--disable-multilib \
	--disable-decimal-float \
	--disable-threads \
	--disable-libatomic \
	--disable-libgomp \
	--disable-libquadmath \
	--disable-libssp \
	--disable-libvtv \
	--disable-libstdcxx \
	--enable-languages=c,c++

# LSF 7.7
# ../libstdc++-v3/configure \
# 	--host=$LFS_TGT \
# 	--prefix=/tools \
# 	--disable-multilib \
# 	--disable-shared \
# 	--disable-nls \
# 	--disable-libstdcxx-threads \
# 	--disable-libstdcxx-pch \
# 	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/4.9.2

make
make install

echo "$S: Total victory!"


