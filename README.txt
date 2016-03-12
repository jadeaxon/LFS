Files for Linux from Scratch 7.7 (LFS).
This is intended to run on Ubuntu 14.10 x86 64-bit.

README.txt
	This file.

README.md
	The GitHub-visible readme.

install-pkgs.sh
	Installs extra Debian pkgs you need to do LFS.

version-check.sh
	Makes sure versions of various pkgs on you dev system will work for LFS.

library-check.sh
	Makes sure libraries on your dev system will work for LFS.

build/
	Where the source tarballs get built.
	The idea is to have a build.sh for each pkg for each phase of building.

tools/
	The toolchain.  Not stored in Git repo.
	This is a temporary place to build stuff for chapter 5.
	It is not the final toolchain.  Still uses host system to help build.

sources/
	Various source tarballs and patches.


