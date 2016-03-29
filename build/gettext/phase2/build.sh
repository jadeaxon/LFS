#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

source /usr/share/lib/bash-glory/LFS.sh

bpkg=gettext # Pkg base name.
ver=0.19.7 # Pkg version.

LFS::init
LFS::debug

#==============================================================================
# Main
#==============================================================================

LFS::extract_archive
LFS::apply_patch

# Build.
cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

# Install.
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
 
LFS::cleanup


