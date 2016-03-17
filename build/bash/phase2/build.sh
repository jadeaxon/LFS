#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

pkg=bash-4.3.30
z=gz
tarball=${pkg}.tar.$z


#==============================================================================
# Main
#==============================================================================

# Extract source tarball.
rm -rf $pkg/
tar xavf $src/$tarball
cd $pkg/

# Apply the patch.
cp $src/bash*.patch .
patch -p1 < bash*.patch


./configure --prefix=/tools --without-bash-malloc
make
make tests
make install

rm -f /tools/bin/sh
ln -sv bash /tools/bin/sh


