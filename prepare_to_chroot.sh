#!/usr/bin/env bash

source /usr/share/lib/bash-glory/filesystem.sh

set -e

S=$(basename $0)

if [ -z "$LFS" ]; then
	echo "$S: ERROR: \$LFS not defined."
	exit 1
fi

# Prepare to chroot to $LFS.
# All commands must be run as root.

# These will be mounted to virtual filesystems.
echo "$S: Setting up virtual filesystem mount points."
sudo mkdir -pv $LFS/{dev,proc,sys,run}

echo "$S: Creating /dev/console and /dev/null."
# Set up device nodes.
# /dev/null and /dev/console must exist at boot before udevd runs.
# udev creates other device nodes.
# You can use udev rules to set up devices in a particular way, rename them, etc.
sudo rm -f $LFS/dev/console
sudo mknod -m 600 $LFS/dev/console c 5 1
sudo rm -f $LFS/dev/null
sudo mknod -m 666 $LFS/dev/null c 1 3

echo "$S: Mirroring host /dev onto $LFS/dev."
# A bind mount mirrors an existing directory.
# It's like a hard link for directories (or a Windows junction).
# We'll mimic the devices defines on the host system.
# In a normal system, /dev is set up by udev at boot.
sudo mount -v --bind /dev $LFS/dev

echo "$S: Mounting host virtual filesystems to $LFS mount points."
# Mount the virtual filesystems.
# Again, we seem to be just mirroring the host system.
# We will create a tty group with group id 5 in the future.
# I think devpts is a device that creates other pseudoterminals.
if ! mounted $LFS/dev/pts; then
	sudo mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
fi
if ! mounted $LFS/proc; then
	sudo mount -vt proc proc $LFS/proc
fi
if ! mounted $LFS/sys; then
	sudo mount -vt sysfs sysfs $LFS/sys
fi
if ! mounted $LFS/run; then
	sudo mount -vt tmpfs tmpfs $LFS/run
fi

echo "$S: Creating directory $LFS/dev/shm points to (if it's a link)."
if [ -h $LFS/dev/shm ]; then
	sudo mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

echo "$S: WIN: You may now run chroot.sh"



