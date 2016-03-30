#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

source /usr/share/lib/bash-glory/LFS.sh

bpkg=bison # Pkg base name.
ver=3.0.4 # Pkg version.

LFS::init
LFS::debug

#==============================================================================
# Main
#==============================================================================

LFS::extract_archive
LFS::apply_patch

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4
make
# make check # You can only run this after Flex is installed.
make install

LFS::cleanup

