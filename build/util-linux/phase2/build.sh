#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

source /usr/share/lib/bash-glory/LFS.sh

bpkg=util-linux # Pkg base name.
ver=2.27.1 # Pkg version.

LFS::init
LFS::debug


#==============================================================================
# Main
#==============================================================================

LFS::extract_archive
LFS::apply_patch

./configure --prefix=/tools \
	--without-python \
	--disable-makeinstall-chown \
	--without-systemdsystemunitdir \
	PKG_CONFIG=""
make
make install

LFS::cleanup


