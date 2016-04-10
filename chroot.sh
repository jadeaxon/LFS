#!/usr/bin/env bash

# PRE: prepare_to_chroot.sh has been run.  You must run this *every* time you reboot your VM.

S=$(basename $0)

if [ ! -d $LFS/dev/pts/ ]; then
	echo "$S: ERROR: You have not run prepare_to_chroot.sh!"
	exit 1
fi

# Run from the toolchain instead of the main Ubuntu system.
bash=/tools/bin/bash
if [ -e $LFS/bin/bash ]; then
	# This is the bash built in phase 3.  Should not exist until then.
	# This path is within the chroot.
	bash=/bin/bash
fi
# We have chroot call env call bash; env believes $LFS is its / dir.
sudo chroot "$LFS" /tools/bin/env -i \
	HOME=/root \
	TERM="$TERM" \
	PS1='\u:\w\$ ' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
	$bash --login +h


# +h tells bash not to hash program paths.
# This makes it so that as we install final versions of commands, they'll come from /usr, etc.
# instead of the toolchain versions (which are initially called).
# This is because /tools/bin is last in PATH (and no hashing).


