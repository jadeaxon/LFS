#!/usr/bin/env bash
# Build coreutils phase 3 for LFS 7.9.
# Fundamental utility programs like cat, mv, cp, etc.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=coreutils-8.25
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

echo "$S: Patching ${pkg}."
patch -Np1 -i $src/coreutils-8.25-i18n-2.patch

FORCE_UNSAFE_CONFIGURE=1 ./configure \
	--prefix=/usr \
	--enable-no-install-program=kill,uptime
FORCE_UNSAFE_CONFIGURE=1 make

make NON_ROOT_USERNAME=nobody check-root
echo "dummy:x:1000:nobody" >> /etc/group
chown -Rv nobody .
su nobody -s /bin/bash \
	-c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
sed -i '/dummy/d' /etc/group

make install

echo "$S: Moving files to FHS-compliant locations."
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
hash
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,sleep,nice,test,[} /bin

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


