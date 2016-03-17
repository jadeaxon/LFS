#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

set -e
shopt -s nullglob

S=$(basename $0)
D=$(pwd)
src=$LFS/sources

pkg=bash-4.3.30
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

./configure --prefix=/tools --without-bash-malloc
make
make tests
make install

rm -f /tools/bin/sh
ln -sv bash /tools/bin/sh

cd $D
rm -rf $pkg
echo "$S: Total victory!"

