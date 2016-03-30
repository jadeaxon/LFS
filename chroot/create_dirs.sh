#!/tools/bin/bash

# Using toolchain here since final bash has not been built.

# PRE: We have chrooted.

set -e
S=$(basename $0)

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}
case $(uname -m) in
	x86_64) 
		rm -f /lib64 /usr/lib64 /usr/local/lib64	
		ln -sv lib /lib64
		ln -sv lib /usr/lib64
		ln -sv lib /usr/local/lib64 ;;
esac
mkdir -pv /var/{log,mail,spool}
rm -f /var/run
ln -sv /run /var/run
rm -f /var/lock
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}

echo "$S: WIN: Directories created."



