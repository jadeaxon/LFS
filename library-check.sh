#!/usr/bin/env bash

# Make sure various libraries exist needed for Linux from Scratch.
for lib in lib{gmp,mpfr,mpc}.la; do
	echo $lib: $(if find /usr/lib* -name $lib|grep -q $lib;then :;else echo not;fi) found
done
unset lib

echo "$0: If none or all were found you are fine.  Otherwise, you have a problem."

