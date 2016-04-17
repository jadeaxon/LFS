#!/usr/bin/env bash
# Build vim phase 3 for LFS 7.9.
# The powerful text editor.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=vim-7.4
pkgd=vim74
archive=$src/${pkg}.tar.bz2

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot environment."
	exit 1
fi

echo "$S: Building $pkg phase 3 (chroot)."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
mv $pkgd $pkg
cd $pkg

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
make -j1 test
make install

# Link vi to vim.
ln -sv vim /usr/bin/vi
for L in /usr/share/man/{,*/}man1/vim.1; do
	ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4

echo "$S: Configuring vim."
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc
set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
	set background=dark
	endif
	" End /etc/vimrc
EOF

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


