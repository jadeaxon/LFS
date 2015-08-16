#!/usr/bin/env bash

# PRE:
# sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

# Run this from /mnt/LFS/sources/build-gcc.

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
