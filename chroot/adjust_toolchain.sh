#!/usr/bin/env bash

# PRE: glibc phase 3 has been installed.
# PRE: You are in chroot env.

set -e

S=$(basename $0)
if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You must run this from the chroot env."
	exit 1
fi

echo "$S: Adjusting toolchain."
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g' \
	-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
	-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
	`dirname $(gcc --print-libgcc-file-name)`/specs

echo
echo "$S: Testing compiler."
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
echo "$S: You should see the following above:"
echo "[Requesting program interpreter: /lib/ld-linux.so.2]"
echo
sleep 5

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
echo "$S: You should see the following above:"
echo "/usr/lib/crt1.o succeeded"
echo "/usr/lib/crti.o succeeded"
echo "/usr/lib/crtn.o succeeded"
echo
sleep 5

grep -B1 '^ /usr/include' dummy.log
echo "$S: You should see the following above:"
echo 'echo "#include <...> search starts here:'
echo '/usr/include'
echo
sleep 5

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
echo "$S: You should see the following above:"
echo 'SEARCH_DIR("/usr/lib")'
echo 'SEARCH_DIR("/lib");'
echo
sleep 5

grep "/lib.*/libc.so.6 " dummy.log
echo "$S: You should see the following above:"
echo 'attempt to open /lib/libc.so.6 succeeded'
echo
sleep 5

grep found dummy.log
echo "$S: You should see the following above:"
echo 'found ld-linux.so.2 at /lib/ld-linux.so.2'
echo
sleep 5

rm -v dummy.c a.out dummy.log
echo "$S: WIN: You have adjusted the chroot toolchain!"




