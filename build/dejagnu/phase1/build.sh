#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

pkg=dejagnu-1.5.2
z=gz
tarball=${pkg}.tar.$z


#==============================================================================
# Main
#==============================================================================

# Extract source tarball.
rm -rf $pkg/
tar xavf $src/$tarball
cd $pkg/

./configure --prefix=/tools
make install
make check





