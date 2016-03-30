#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

bpkg=perl # Pkg base name.
ver=5.20.2 # Pkg version.
pkg=${bpkg}-${ver} # Full pkg name.
z=bz2 # Compression style.
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

sh Configure -des -Dprefix=/tools -Dlibs=-lm
make
cp -v perl cpan/podlators/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.20.2
cp -Rv lib/* /tools/lib/perl5/5.20.2

cd ..
rm -rf $pkg/
echo "$S: You have built $pkg from scratch!"


