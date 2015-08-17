#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e

src='../../../sources'
src=$(cd $src; pwd) # Convert to absolute path.

S=$(basename $0)

bpkg=gettext # Pkg base name.
ver=0.19.4 # Pkg version.
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

cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

# Install the commands build above.
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
cd ..

cd ..
rm -rf $pkg/
echo "$S: You have built $pkg from scratch!"


