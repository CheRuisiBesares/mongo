#!/bin/bash

REPOSITORY=$1
if [ -z "$REPOSITORY" ]; then
  REPOSITORY=/var/www/mongodb-repo
fi

ln -s mongodb-org-unstable.control debian/control
ln -s mongodb-org-unstable.rules debian/rules
ln -s mongodb-org-unstable-server.postinst debian/postinst
scons --64 --release --no-glibc-check -j 2 --prefix=$(pwd)/BINARIES/usr install
debuild -i -uc -us -b
mkdir -p $REPOSITORY/binary
mv ../mongodb-org-unstable*.deb $REPOSITORY/binary
(cd $REPOSITORY && dpkg-scanpackages binary /dev/null | gzip -9c > binary/Packages.gz)
