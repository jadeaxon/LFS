#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

pkg=check-0.9.14
z=gz
tarball=${pkg}.tar.$z


#==============================================================================
# Main
#==============================================================================

# Extract source tarball.
rm -rf $pkg/
tar xavf $src/$tarball
cd $pkg/


PKG_CONFIG= ./configure --prefix=/tools
make
make check
make install



