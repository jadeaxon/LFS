#!/usr/bin/env bash

# Builds and installs gcc phase 2 for the LFS toolchain.

#==============================================================================
# Variables
#==============================================================================

set -e
shopt -s nullglob

S=$(basename $0)
D=$(pwd)
src=$LFS/sources

pkg=gcc-5.3.0
archive=( $src/${pkg}.tar.* ) # Expand glob into an array.
archive=${archive[0]}


#==============================================================================
# Functions
#==============================================================================

extract_archive() {
	echo "$S: Extracting archive $archive."
	rm -rf $pkg
	tar xavf $archive
	cd $pkg
}

apply_patch() {
	patch=( $src/${pkg}*.patch )
	patch=${patch[0]}
	if [ "$patch" ]; then
		echo "$S: Patching ${pkg} with ${patch}."
		patch -p1 < $patch
	fi
}

# Changes the linker location.
change_linker_location() {
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
}

# Gets extra stuff that needs to build inside gcc dir.
include_dependencies() {
	rm -rf mpfr gmp mpc

	tar -xf $src/mpfr-3.1.3.tar.xz
	mv -v mpfr-3.1.3 mpfr
	cd mpfr
	patch -p1 < $src/mpfr*.patch
	cd -

	tar -xf $src/gmp-6.1.0.tar.xz
	mv -v gmp-6.1.0 gmp

	tar -xf $src/mpc-1.0.3.tar.gz
	mv -v mpc-1.0.3 mpc
}

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

echo "$S: Building $pkg phase 2 for ${LFS_TGT}."
extract_archive
apply_patch

# Make a special limit.h.
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	$(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/include-fixed/limits.h

change_linker_location
include_dependencies

mkdir build
cd build

# Configure and build the C and C++ compilers from the GNU Compiler Collection.
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure \
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

# Allows sysadmin to have cc be whatever compiler they want (maybe clang).
rm -f /tools/bin/cc
ln -sv gcc /tools/bin/cc

test_compiler

echo "$S: Total victory!"


