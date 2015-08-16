# Configures binutils during phase 2 of LFS.

CC=$LFS_TGT-gcc \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../binutils-2.25/configure \
	--prefix=/tools \
	--disable-nls \
	--disable-werror \
	--with-lib-path=/tools/lib \
	--with-sysroot


