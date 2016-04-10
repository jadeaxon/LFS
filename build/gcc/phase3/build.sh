#!/usr/bin/env bash
# Build gcc phase 3 for LFS 7.9.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources
pkg=gcc-5.3.0
archive=$src/${pkg}.tar.bz2

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot environment."
	exit 1
fi

echo "$S: Building $pkg phase 3 (chroot)."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

mkdir -v build
cd build

SED=sed \
../configure --prefix=/usr \
	--enable-languages=c,c++ \
	--disable-multilib \
	--disable-bootstrap \
	--with-system-zlib
make
ulimit -s 32768 # Increase the stack size.
make -k check
# I ran everything from here on manually.
# There were more failures than in the book.  However, most of them were timeout failures.
# Also, the book is geared more toward an 32-bit build than a 64-bit build.
# All the output checks of the compile test were fine.
../contrib/test_summary

while true; do
	read -p "Do you wish to install gcc? " response
	case $response in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer 'yes' or 'no'.";;
	esac
done

make install

echo "$S: Creating links."
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc

install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.3.0/liblto_plugin.so /usr/lib/bfd-plugins/

# Test compilation.
echo "$S: Testing new compiler."
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
echo "$S: You should see this above:"
echo "/usr/lib/gcc/i686-pc-linux-gnu/5.3.0/../../../crt[1in].o succeeded"
echo

grep -B4 '^ /usr/include' dummy.log

# /usr/lib/gcc/i686-pc-linux-gnu/5.3.0/include
# /usr/local/include
# /usr/lib/gcc/i686-pc-linux-gnu/5.3.0/include-fixed
# /usr/include

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
# SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib64")
# SEARCH_DIR("/usr/local/lib64")
# SEARCH_DIR("/lib64")
# SEARCH_DIR("/usr/lib64")
# SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib")
# SEARCH_DIR("/usr/local/lib")
# SEARCH_DIR("/lib")
# SEARCH_DIR("/usr/lib");

grep "/lib.*/libc.so.6 " dummy.log
# attempt to open /lib/libc.so.6 succeeded

grep found dummy.log
# found ld-linux.so.2 at /lib/ld-linux.so.2

rm -v dummy.c a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

cd ..
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"


