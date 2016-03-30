#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

source /usr/share/lib/bash-glory/LFS.sh

bpkg=texinfo # Pkg base name.
ver=6.1 # Pkg version.

LFS::init
LFS::debug


#==============================================================================
# Main
#==============================================================================

LFS::extract_archive
LFS::apply_patch

./configure --prefix=/tools
make
make check
make install

LFS::cleanup


