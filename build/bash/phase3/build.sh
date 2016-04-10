#!/usr/bin/env bash
# Build bash phase 3 for LFS 7.9.
# Bash is the standard Unix shell (the Bourne Again Shell).

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=bash-4.3.30
archive=$src/${pkg}.tar.gz

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot environment."
	exit 1
fi

echo "$S: Building $pkg phase 3 (chroot)."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

echo "$S: Patching ${pkg}."
patch -Np1 -i $src/bash-4.3.30-upstream_fixes-3.patch

./configure --prefix=/usr \
	--docdir=/usr/share/doc/bash-4.3.30 \
	--without-bash-malloc \
	--with-installed-readline
make
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make tests"
make install
mv -vf /usr/bin/bash /bin

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"
echo "$S: Run this to start new shell: 'exec /bin/bash --login +h'." 


