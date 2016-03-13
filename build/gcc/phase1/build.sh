#!/usr/bin/env bash

set -e

# PRE: This script is run from the directory containing it.
# PRE:
# sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

S=$(basename $0)

# TO DO: Extract archive here.
# TO DO: Update for LFS 7.9.

../gcc-4.9.2/configure \
	--target=$LFS_TGT \
	--prefix=/tools \
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
	--disable-libitm \
	--disable-libquadmath \
	--disable-libsanitizer \
	--disable-libssp \
	--disable-libvtv \
	--disable-libcilkrts \
	--disable-libstdc++-v3 \
	--enable-languages=c,c++

# Run this from the $LFS/sources/gcc-build/.
# This should be an empty dir, not the one you just used to build gcc itself.
../gcc-4.9.2/libstdc++-v3/configure \
	--host=$LFS_TGT \
	--prefix=/tools \
	--disable-multilib \
	--disable-shared \
	--disable-nls \
	--disable-libstdcxx-threads \
	--disable-libstdcxx-pch \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/4.9.2

# Prepares gcc for building (in a separate dir).
# Run this script from the extracted tarball dir.
rm -rf mpfr
rm -rf gmp
rm -rf mpc

echo "$S: Including mpfr, gmp, and mpc."
tar -xf ../mpfr-3.1.2.tar.xz
mv -v mpfr-3.1.2 mpfr
tar -xf ../gmp-6.0.0a.tar.xz
mv -v gmp-6.0.0 gmp
tar -xf ../mpc-1.0.2.tar.gz
mv -v mpc-1.0.2 mpc

echo "$S: Patching mpfr."
cd mpfr
cp ../../mpfr*.patch .
patch -p1 < mpfr*.patch
cd -

echo "$S: Forcing gcc to use LFS dynamic linker."
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

echo "$S: Fixing a 32-bit issue."
sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

echo "$S: Creating separate build dir."
mkdir -v ../gcc-build
cd ../gcc-build

echo "$S: gcc is now ready to be configured and built."

make
make install

echo "$S: Total victory!"


