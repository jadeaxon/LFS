#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e
shopt -s nullglob

S=$(basename $0)
D=$(pwd)
src=$LFS/sources

pkg=tcl8.6.4
pkg_file=tcl-core8.6.4-src
archive=( $src/${pkg_file}.tar.* ) # Expand glob into an array.
archive=${archive[0]}

echo $archive

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


#==============================================================================
# Main
#==============================================================================

extract_archive
apply_patch

cd unix
./configure --prefix=/tools

# We're not going to use a separate build dir for TCL.
make
TZ=UTC make test

make install

lib=/tools/lib/libtcl8.6.so
if [ ! -f $lib ]; then
	echo "$S: ERROR: $lib DNE."
	exit 1
fi

chmod -v u+w $lib
make install-private-headers

rm -f /tools/bin/tclsh
ln -sv tclsh8.6 /tools/bin/tclsh

cd $D
rm -rf $pkg

echo "$S: Total victory!"

