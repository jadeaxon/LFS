#!/usr/bin/env bash

# Perform toolchain sanity check from chapter 5.
S=$(basename $0)
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
rm -v dummy.c a.out
echo "$S: You should see /tools/lib64/ld-linux-x86-64.so.2 requested on a 64-bit machine."

