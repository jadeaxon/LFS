#!/usr/bin/env bash
# Build glibc phase 3 for LFS 7.9.

# PRE: You are in the chroot env.

set -e

S=$(basename $0)
D=$(pwd)
src=/sources
pkg=glibc-2.23
archive=$src/${pkg}.tar.*

if [ ! -e /CHROOT ]; then
	echo "$S: ERROR: You are not in the chroot env."
	exit 1
fi

echo "$S: Building $pkg phase 3."

rm -rf $pkg
echo "$S: Extracting archive $archive."
tar xavf $archive
cd $pkg

echo "$S: Patching ${pkg}."
patch -Np1 -i $src/glibc-2.23-fhs-1.patch

mkdir -v build
cd build

echo "$S: Configuring $pkg phase 3."
../configure --prefix=/usr \
	--disable-profile \
	--enable-kernel=2.6.32 \
	--enable-obsolete-rpc

make
make check
touch /etc/ld.so.conf
make install

cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

echo "$S: Creating locales."
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

make localedata/install-locales

echo "$S: Configuring glibc."
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf
passwd: files
group: files
shadow: files
hosts: files dns
networks: files
protocols: files
services: files
ethers: files
rpc: files
# End /etc/nsswitch.conf
EOF

echo "$S: Setting up timezones."
tar -xf ../../tzdata2016a.tar.gz
ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica \
	asia australasia backward pacificnew systemv; do
zic -L /dev/null -d $ZONEINFO -y "sh yearistype.sh" ${tz}
zic -L /dev/null -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO


echo "$S: Configuring dynamic loader."
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
EOF
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF
mkdir -pv /etc/ld.so.conf.d

cd $D
rm -rf $pkg
echo "$S: WIN: You have built $pkg from scratch!"
echo "$S: You need to run this:"
echo "cp -v /usr/share/zoneinfo/<your time zone> /etc/localtime"
echo "$S: Current timezone:"
tzselect


