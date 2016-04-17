#!/usr/bin/env bash
# Build texinfo phase 3 for LFS 7.9.
# Tools for reading, writing, and converting info pages.  The successor to man pages.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=texinfo-6.1
archive=$src/${pkg}.tar.xz

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot environment."
	exit 1
fi

echo "$S: Building $pkg phase 3 (chroot)."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

./configure --prefix=/usr --disable-static
make
make check
make install
make TEXMF=/usr/share/texmf install-tex

pushd /usr/share/info
rm -v dir
for f in *
	do install-info $f dir 2>/dev/null
done
popd

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


