#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e
shopt -s nullglob

S=$(basename $0)
D=$(pwd)
src=$LFS/sources

bpkg=coreutils # Pkg base name.
ver=8.25 # Pkg version.
pkg=${bpkg}-${ver} # Full pkg name.
archive=( $src/${pkg}.tar.* ) # Expand glob into an array.
archive=${archive[0]}


#==============================================================================
# Functions
#==============================================================================

extract_archive() {
    echo "$S: Extracting archive $archive."
    rm -rf $pkg
    tar xavf $archive
    cd $pkg
}

apply_patch() {
    patch=( $src/${pkg}*.patch )
    patch=${patch[0]}
    if [ "$patch" ]; then
        echo "$S: Patching ${pkg} with ${patch}."
        patch -p1 < $patch
    fi
}

 
#==============================================================================
# Main
#==============================================================================

extract_archive
apply_patch

./configure --prefix=/tools --enable-install-program=hostname
make
make RUN_EXPENSIVE_TESTS=yes check
make install

cd $D
rm -rf $pkg
echo "$S: Total victory!"


