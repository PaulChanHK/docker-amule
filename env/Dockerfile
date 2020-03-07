
# references:
# 1. https://github.com/alpinelinux/aports/blob/master/testing/amule/APKBUILD
# 2. https://github.com/tchabaud/dockerfiles/blob/afe0fc68d12eb3d89693320b18a9d7018ef3bc31/amule/Dockerfile

FROM alpine:latest

LABEL maintainer="https://github.com/PaulChanHK/docker-amule/tree/master/env"

# update source list
# then pull packages list and perform packages upgrade
RUN ( apk --update --no-cache add \
       sudo bash \
       git wget \
       alpine-sdk coreutils cmake \
       automake autoconf libtool \
       bison boost-dev \
       musl-dev gd-dev geoip-dev libsm-dev wxgtk-dev \
       gettext-dev libpng-dev libwebp-dev zlib-dev \
       gd geoip wxgtk \
       gettext libpng libwebp pwgen zlib \
    )

ENV LANGUAGE en_US:en

ENTRYPOINT ["/bin/bash", "-c", "sleep infinity"]
