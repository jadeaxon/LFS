#!/usr/bin/env bash

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
