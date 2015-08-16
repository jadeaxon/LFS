#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

pkg=expect5.45
z=gz
tarball=${pkg}.tar.$z


#==============================================================================
# Main
#==============================================================================

# Extract source tarball.
rm -rf $pkg/
tar xavf $src/$tarball
cd $pkg/

# Make sure we use the right stty.
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

./configure --prefix=/tools \
	--with-tcl=/tools/lib \
	--with-tclinclude=/tools/include

make
make test
make SCRIPTS="" install




