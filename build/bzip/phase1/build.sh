#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

pkg=bzip2-1.0.6
z=gz
tarball=${pkg}.tar.$z


#==============================================================================
# Main
#==============================================================================

# Extract source tarball.
rm -rf $pkg/
tar xavf $src/$tarball
cd $pkg/

# Apply the batch.
cp $src/bzip*.patch .
patch -p1 < bzip*.patch

# Build and install to toolchain.
make
make PREFIX=/tools install




