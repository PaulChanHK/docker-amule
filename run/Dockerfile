
# references:
# 1. https://github.com/alpinelinux/aports/blob/master/testing/amule/APKBUILD
# 2. https://github.com/tchabaud/dockerfiles/blob/afe0fc68d12eb3d89693320b18a9d7018ef3bc31/amule/Dockerfile

ARG ENV_IMG="paulchan/amule:env-1.0"

ARG SRC_GIT="https://github.com/amule-project/amule"
ARG SRC_BCH="2.3.2"

ARG UPNP_GIT="https://github.com/pupnp/pupnp"
ARG UPNP_BCH="release-1.6.22"

ARG CRYP_GIT="https://github.com/weidai11/cryptopp"
ARG CRYP_BCH="CRYPTOPP_5_6_5"


################

FROM ${ENV_IMG} as pkg_build

ARG SRC_GIT
ARG SRC_BCH

ARG UPNP_GIT
ARG UPNP_BCH
    
ARG CRYP_GIT
ARG CRYP_BCH

WORKDIR /tmp

RUN ( git clone ${UPNP_GIT} -b ${UPNP_BCH} --single-branch \
  && mkdir -p /pkg \
  && cd pupnp* \
  && export VERGIT=$(git describe --tags) \
  && export OLDTAG=$(git describe --tags --abbrev=0 HEAD^) \
  && { echo "Git version : $VERGIT" \
  &&   echo "Git branch  : ${SRC_BCH}" \
  &&   echo "Git remote  : $(git remote -v | head -n1)" \
  &&   echo "Git old tag : $OLDTAG" \
  &&   echo Changes in $OLDTAG..HEAD : \
  &&   git log --pretty=oneline $OLDTAG..HEAD | \
       sed -r 's/^([0-9a-f]{8})[0-9a-f]{32}(.*)/\1\2/'; } | tee /pkg/CHANGES_UPNP \
  && libtoolize --force && aclocal && autoheader \
  && automake --force-missing --add-missing \
  && autoconf \
  && ./configure --prefix=/usr >/dev/null  \
  && make -j$(nproc) >/dev/null \
  && make install \
  && make DESTDIR=/pkg install \
  )

RUN ( git clone ${CRYP_GIT} -b ${CRYP_BCH} --single-branch \
  && mkdir -p /pkg \
  && cd cryptopp* \
  && export VERGIT=$(git describe --tags) \
  && export OLDTAG=$(git describe --tags --abbrev=0 HEAD^) \
  && { echo "Git version : $VERGIT" \
  &&   echo "Git branch  : ${SRC_BCH}" \
  &&   echo "Git remote  : $(git remote -v | head -n1)" \
  &&   echo "Git old tag : $OLDTAG" \
  &&   echo Changes in $OLDTAG..HEAD : \
  &&   git log --pretty=oneline $OLDTAG..HEAD | \
       sed -r 's/^([0-9a-f]{8})[0-9a-f]{32}(.*)/\1\2/'; } | tee /pkg/CHANGES_CRYP \
  && sed -i -e 's/^CXXFLAGS/#CXXFLAGS/' GNUmakefile \
  && export CXXFLAGS="${CXXFLAGS} -DNDEBUG -fPIC" \
  && make -j$(nproc) -f GNUmakefile  >/dev/null \
  && make -j$(nproc) libcryptopp.so  >/dev/null \
  && mkdir -p /usr/include/cryptopp /pkg/usr/include/cryptopp \
  && install -Dm644 libcryptopp.so* /usr/lib/ \
  && install -m644 *.h /usr/include/cryptopp/ \
  && install -Dm644 libcryptopp.so* /pkg/usr/lib/ \
  && install -m644 *.h /pkg/usr/include/cryptopp/ \
  )

RUN ( git clone ${SRC_GIT} -b ${SRC_BCH} --single-branch \
  && mkdir -p /pkg \
  && cd amule* \
  && export VERGIT=$(git describe --tags) \
  && export VERSTR=$(echo $VERGIT | sed -e 's/^v//' -e 's/_/./g') \
  && echo VERSTR=$VERSTR \
  && export OLDTAG=$(git describe --tags --abbrev=0 HEAD^) \
  && { echo "Git version : $VERGIT" \
  &&   echo "Git branch  : ${SRC_BCH}" \
  &&   echo "Git remote  : $(git remote -v | head -n1)" \
  &&   echo "Git old tag : $OLDTAG" \
  &&   echo Changes in $OLDTAG..HEAD : \
  &&   git log --pretty=oneline $OLDTAG..HEAD | \
       sed -r 's/^([0-9a-f]{8})[0-9a-f]{32}(.*)/\1\2/'; } | tee /pkg/CHANGES \
  && ./autogen.sh >/dev/null \
  && ./configure \
      --disable-gui \
      --disable-amule-gui \
      --disable-wxcas \
      --disable-alc \
      --disable-plasmamule \
      --disable-kde-in-home \
      --prefix=/usr \
      --mandir=/usr/share/man \
      --enable-unicode \
      --without-subdirs \
      --without-expat \
      --enable-amule-daemon \
      --enable-amulecmd \
      --enable-webserver \
      --enable-cas \
      --enable-alcc \
      --enable-fileview \
      --enable-geoip \
      --enable-mmap \
      --enable-optimize \
      --enable-upnp \
      --disable-debug \
      >/dev/null  \
  && make -j$(nproc) >/dev/null \
  && make DESTDIR=/pkg install  \
  )

# Install a nicer web ui
RUN cd /pkg/usr/share/amule/webserver \
    && git clone https://github.com/MatteoRagni/AmuleWebUI-Reloaded \
    && rm -rf AmuleWebUI-Reloaded/.git AmuleWebUI-Reloaded/doc-images

################

FROM alpine:latest

LABEL maintainer="https://github.com/PaulChanHK/docker-amule/tree/master/run"

COPY --from=pkg_build /pkg /

# update source list
# then pull packages list and perform packages upgrade
RUN ( apk --update --no-cache add \
       bash musl gd geoip wxgtk \
       gettext libpng libwebp pwgen zlib \
      && rm -rf /var/cache/apk/* \
    )

# Add startup script
ADD entrypoint.sh /home/amule/entrypoint.sh

EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp

# for debug
#ENTRYPOINT ["/bin/bash", "-c", "sleep infinity"]

ENTRYPOINT ["/home/amule/entrypoint.sh"]
CMD ["-c", "/home/amule/.aMule", "-o"]
