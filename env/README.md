# docker-amule/env

Alpine docker container for compiling amule.

Usage
---------------

Build the image
```
docker build -t amule-env .
or
# configure your env in set_env.sh
source set_env.sh
# run script to perform docker build with your env
./build.sh
```

Run the container
```
docker run -d --name amule-env amule-env
# enter bash
docker exec -ti amule-env bash
```
