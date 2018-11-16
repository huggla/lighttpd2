ARG TAG="20181113-edge"

FROM huggla/alpine-official:$TAG as alpine

#ARG BUILDDEPS="glib libev ragel lua zlib libbz2 libressl2.7-libssl"
ARG BUILDDEPS="gcc g++ glib-dev make libtool automake autoconf libev-dev lua-dev zlib-dev libressl-dev perl mailcap ssl_client"
ARG DOWNLOAD="https://git.lighttpd.net/lighttpd/lighttpd2.git/snapshot/lighttpd2-master.tar.gz"
ARG DESTDIR="/lighttpd2"

RUN mkdir -p "$DESTDIR/run/fastcgi" \
 && apk add $BUILDDEPS \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && wget $DOWNLOAD \
 && tar -xvp -f lighttpd2-master.tar.gz --strip-components 1 \
 && ./autogen.sh \
 && ./configure --prefix=/usr/local --with-lua --with-openssl --with-kerberos5 --with-zlib --with-bzip2 --includedir=/usr/include/lighttpd2 \
 && make \
 && make install \
 && perl contrib/create-mimetypes.conf.pl > "$DESTDIR/mimetypes.conf" \
 && mv contrib/default.html "$DESTDIR/default.html"

 
