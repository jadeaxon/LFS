#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

bpkg=coreutils # Pkg base name.
ver=8.23 # Pkg version.
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
cp $src/${bpkg}*.patch .
patch -p1 < ${bpkg}*.patch

./configure --prefix=/tools --enable-install-program=hostname
make
make RUN_EXPENSIVE_TESTS=yes check
make install


