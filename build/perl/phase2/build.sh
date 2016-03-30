#!/usr/bin/env bash

#==============================================================================
# Variables
#==============================================================================

source /usr/share/lib/bash-glory/LFS.sh

bpkg=perl # Pkg base name.
ver=5.22.1 # Pkg version.

LFS::init
LFS::debug

#==============================================================================
# Main
#==============================================================================

LFS::extract_archive
LFS::apply_patch

sh Configure -des -Dprefix=/tools -Dlibs=-lm
make
cp -v perl cpan/podlators/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/$ver
cp -Rv lib/* /tools/lib/perl5/$ver

LFS::cleanup


