#!/usr/bin/env bash

# PRE: setup_devices.sh has been run.

# Run from the toolchain instead of the main Ubuntu system.
chroot "$LFS" /tools/bin/env -i \
	HOME=/root \
	TERM="$TERM" \
	PS1='\u:\w\$ ' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
	/tools/bin/bash --login +h


# +h tells bash not to hash program paths.
# This makes it so that as we install final versions of commands, they'll come from /usr, etc.
# instead of the toolchain versions (which are initially called).
# This is because /tools/bin is last in PATH (and no hashing).


