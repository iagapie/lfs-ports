#!/bin/bash

CURDIR=$(cd "$(dirname $0)" && pwd)
XDIR="$CURDIR/../xorg"

mkdir -p $XDIR

for p in $(grep -v '^#' $CURDIR/md5/x-app.md5 | awk '{print $2}'); do
    n=$(echo $p | sed 's/^\(.*\)-\(.*\)/\1/')
    nl=$(echo $n | awk '{print tolower($0)}')
    v=$(echo $p | sed 's/^\(.*\)-\(.*\).tar.\(.*\)/\2/')
    ar=$(echo $p | sed 's/^\(.*\)-\(.*\).tar.\(.*\)$/tar.\3/')

    mkdir -p $XDIR/$nl

    xc=""
    xp=""

    case $p in
       luit-[0-9]* )
            xc='sed -i -e "/D_XOPEN/s/5/6/" configure'
        ;;
        xrandr-*)
            xp='rm -f $PKG/usr/bin/xkeystone'
        ;;
    esac

    cat <<EOF > $XDIR/$nl/spkgbuild
# description	: $nl
# maintainer	: iagapie, igoragapie at gmail.com
# depends	    : 

name=$nl
version=$v
release=1
source="ftp://ftp.x.org/pub/individual/app/$n-\$version.$ar"

build() {
	cd $n-\$version

    $xc
    
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static
    make
	make DESTDIR=\$PKG install

    $xp
}
EOF
done