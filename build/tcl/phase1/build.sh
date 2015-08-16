#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

pkg=tcl8.6.3
z=gz
tarball=${pkg}-src.tar.$z


#==============================================================================
# Main
#==============================================================================

# Extract source tarball.
rm -rf $pkg/
tar xavf $src/$tarball
cd $pkg/

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


