#!/bin/bash

CURDIR=$(cd "$(dirname $0)" && pwd)
XDIR="$CURDIR/../xorg"

mkdir -p $XDIR

if [ ! -f $XDIR/list ]; then
    touch $XDIR/list
fi

deps=""

for p in $(grep -v '^#' $CURDIR/libs | awk '{print $2}'); do
    n=$(echo $p | sed 's/^\(.*\)-\(.*\)/\1/')
    nl=$(echo $n | awk '{print tolower($0)}')
    v=$(echo $p | sed 's/^\(.*\)-\(.*\).tar.\(.*\)/\2/')
    ar=$(echo $p | sed 's/^\(.*\)-\(.*\).tar.\(.*\)$/tar.\3/')

    mkdir -p $XDIR/$nl

    xc="./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

    case $p in
        libICE* )
            xc="$xc ICE_LIBS=-lpthread"
        ;;

        libXfont2-[0-9]* )
            xc="$xc --disable-devel-docs"
        ;;

        libXt-[0-9]* )
            xc="$xc --with-appdefaultdir=/etc/X11/app-defaults"
        ;;
    esac

    cat <<EOF > $XDIR/$nl/Pkgfile
# Description:
# URL:
# Maintainer:
# Depends on: fontconfig libxcb$deps 

name=$nl
version=$v
release=1
source=(ftp://ftp.x.org/pub/individual/lib/$n-\$version.$ar)

build() {
	cd $n-\$version

    $xc
    make
	make DESTDIR=\$PKG install
}
EOF

    deps=" $nl"
    grep -qxF "$nl" $XDIR/list || echo "$nl" >> $XDIR/list
done