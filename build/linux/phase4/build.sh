#!/usr/bin/env bash
# Build the Linux kernel phase 4 for LFS 7.9.

# PRE: You are in the chroot environment.

# NOTE: Until we have dpkg available in the chroot environment, we can't use my bash-glory package.

set -e

S=$(basename $0)
src=/sources # Note that this is no longer /mnt/LFS/sources
pkg=linux-4.4.2
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

make mrproper
make defconfig
# NOTE: I manually did the rest of the step.
# For boot from USB, I tried this:
# http://www.linuxquestions.org/questions/linux-from-scratch-13/lfs-7-8-setting-up-grub-to-boot-from-flash-drive-4175572965/
make LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 menuconfig
make
make modules_install

# Put files where GRUB can use them.
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-4.4.2-lfs-7.9
cp -v System.map /boot/System.map-4.4.2
cp -v .config /boot/config-4.4.2

# Install kernel documentation.
install -d /usr/share/doc/linux-4.4.2
cp -r Documentation/* /usr/share/doc/linux-4.4.2

# Make kernel source owned by root.
chown -R 0:0 .

# Load USB in the correct order.
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
# End /etc/modprobe.d/usb.conf
EOF


# cd ..
# rm -rf $pkg
echo "$S: Total victory!"




