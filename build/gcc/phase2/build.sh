#!/usr/bin/env bash

# Builds and installs gcc phase 2 for the LFS toolchain.


#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)


#==============================================================================
# Functions
#==============================================================================

# Tests that the toolchain compiler works.
test_compiler() {
	echo 'main(){}' > dummy.c
	cc dummy.c
	readelf -l a.out
	# /tools/lib64/ld-linux-x86-64.so.2	
	good=$(readelf -l a.out | grep ': /tools' | pcregrep -c '/tools/lib(64)?/ld-linux.*[.]so[.]2') || true
	rm -f dummy.c a.out
	if (( ! good )); then
		echo "$S: ERROR: Toolchain compiler not working as expected."
		exit 1
	fi
}


#==============================================================================
# Main
#==============================================================================


# Extract source tarball.
rm -rf gcc-4.9.2/
tar xavf $src/gcc-4.9.2.tar.bz2

cd gcc-4.9.2/

# Make a special limit.h.
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	$(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/include-fixed/limits.h

# Change linker location.
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

# Get extra stuff that needs to build inside gcc dir.
rm -rf mpfr gmp mpc

tar -xf $src/mpfr-3.1.2.tar.xz
mv -v mpfr-3.1.2 mpfr
cd mpfr
cp $src/mpfr*.patch .
patch -p1 < mpfr*.patch
cd ..

tar -xf $src/gmp-6.0.0a.tar.xz
mv -v gmp-6.0.0 gmp

tar -xf $src/mpc-1.0.2.tar.gz
mv -v mpc-1.0.2 mpc

cd ..
rm -rf build
mkdir build
cd build

# Configure gcc.
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../gcc-4.9.2/configure \
	--prefix=/tools \
	--with-local-prefix=/tools \
	--with-native-system-header-dir=/tools/include \
	--enable-languages=c,c++ \
	--disable-libstdcxx-pch \
	--disable-multilib \
	--disable-bootstrap \
	--disable-libgomp


make
make install

rm -f /tools/bin/cc
ln -sv gcc /tools/bin/cc

test_compiler


