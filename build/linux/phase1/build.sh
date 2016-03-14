#!/usr/bin/env bash
# Build Linux headers phase 1 for LFS 7.9.

set -e

S=$(basename $0)
src=/mnt/LFS/sources
# linux-4.4.2.tar.xz
pkg=linux-4.4.2
archive=$src/${pkg}.tar.xz

echo "$S: Building $pkg phase 1 for ${LFS_TGT}."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

make mrproper
make headers_check
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

rm -rf $pkg
echo "$S: Total victory!"





