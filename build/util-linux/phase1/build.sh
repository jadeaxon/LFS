#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

bpkg=util-linux # Pkg base name.
ver=2.26 # Pkg version.
pkg=${bpkg}-${ver} # Full pkg name.
z=xz # Compression style.
tarball=${pkg}.tar.$z # Tarball filename.


#==============================================================================
# Main
#==============================================================================

# Extract source tarball.
rm -rf $pkg/
tar xavf $src/$tarball
cd $pkg/

# Apply the batch.
if [ -f $src/${bpkg}*.patch ]; then
	cp $src/${bpkg}*.patch .
	patch -p1 < ${bpkg}*.patch
fi

./configure --prefix=/tools \
	--without-python \
	--disable-makeinstall-chown \
	--without-systemdsystemunitdir \
	PKG_CONFIG=""
make
make install

cd ..
rm -rf $pkg/
echo "$S: You have built $pkg from scratch!"


