#!/bin/bash

CURDIR=$(cd "$(dirname $0)" && pwd)
XDIR="$CURDIR/../xorg"

mkdir -p $XDIR

for p in $(grep -v '^#' $CURDIR/md5/x-font.md5 | awk '{print $2}'); do
    n=$(echo $p | sed 's/^\(.*\)-\(.*\)/\1/')
    nl=$(echo $n | awk '{print tolower($0)}')
    v=$(echo $p | sed 's/^\(.*\)-\(.*\).tar.\(.*\)/\2/')
    ar=$(echo $p | sed 's/^\(.*\)-\(.*\).tar.\(.*\)$/tar.\3/')

    mkdir -p $XDIR/$nl

    cat <<EOF > $XDIR/$nl/spkgbuild
# description	: $nl
# maintainer	: iagapie, igoragapie at gmail.com
# depends	    : 

name=$nl
version=$v
release=1
source="https://www.x.org/pub/individual/font/$n-\$version.$ar"

build() {
	cd $n-\$version

    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static
    make
	make DESTDIR=\$PKG install

    find $PKG -name 'fonts.scale' -delete	
	find $PKG -name 'fonts.dir' -delete
}
EOF
done