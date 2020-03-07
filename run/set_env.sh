#!/bin/sh

export SRC_BCH=${1:-"master"}
export ENV_IMG=${2:-"amule-env"}
export BUILD_ARG=${3}

IMAGE_NAME=${IMAGE_NAME:-amule-run}
if [[ -n "$SRC_BCH" && "$SRC_BCH" != "master" ]]; then
  if [ "${IMAGE_NAME/:/}" != "$IMAGE_NAME" ]; then
    IMAGE_NAME="${IMAGE_NAME%:*}:${IMAGE_NAME##*:}-$SRC_BCH"
  else
    IMAGE_NAME="${IMAGE_NAME}:latest-$SRC_BCH"
  fi
fi
export IMAGE_NAME
