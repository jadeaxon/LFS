#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

source /usr/share/lib/bash-glory/LFS.sh

bpkg='grep' # Pkg base name.
ver=2.23 # Pkg version.

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


