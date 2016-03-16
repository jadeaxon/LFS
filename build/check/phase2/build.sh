#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e
shopt -s nullglob

S=$(basename $0)
D=$(pwd)
src=$LFS/sources

pkg=check-0.10.0
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

PKG_CONFIG= ./configure --prefix=/tools
make
make check
make install

rm -rf $pkg
echo "$S: Total victory!"


