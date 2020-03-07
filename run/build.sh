#!/bin/bash

export DOCKERFILE_PATH=${DOCKERFILE_PATH:-Dockerfile}
export IMAGE_NAME=${IMAGE_NAME:-amule-run}

arg_str=""
for v in SRC_BCH ENV_IMG BUILD_ARG; do
[ -z `eval "echo \\\${$v}"` ] || arg_str="$arg_str --build-arg $v"
done

docker build $arg_str -f $DOCKERFILE_PATH -t $IMAGE_NAME "$@" .
