# docker-amule/run

Alpine docker container for running amule.

Type      | Source URL
---       | ---
aMule     | https://github.com/amule-project/amule
docker    | https://github.com/PaulChanHK/docker-amule/tree/master/run

# Notice

This Dockerfile is only for x86_64 architecture only. If you're interested in ARM port, have a look at [this fork](https://github.com/synopsis8/dockerfiles).
All credits go to [tchabaud](https://github.com/tchabaud/dockerfiles), this docker container just implements some improvements in container:
- use an env docker for compilation
- multi-stage build for this container
- add a usage note about quick-run below

In the following commands,
```
# local built docker image = amule-run, or
# docker hub image = paulchan/amule, or tag like paulchan/amule:v2.3.2-p.2
```

# Usage

## Configuration

Create needed directories with

```sh
mkdir -p ./amule/conf
mkdir -p ./amule/tmp
mkdir -p ./amule/incoming
```

## Build the image
```
docker build -t amule-run .
or
# configure your env in set_env.sh
source set_env.sh
# run script to perform docker build with your env
./build.sh
```

## Quick run of the container

Run the following command to start the container:

```sh
docker run -d --name amule \
    -p 4712:4712 -p 4711:4711 -p 4662:4662 -p 4665:4665/udp -p 4672:4672/udp \
    -e PUID=[wanted_uid] -e PGID=[wanted_gid] \
    -e GUI_PWD=[wanted_password_for_gui] \
    -e WEBUI_PWD=[wanted_password_for_web_interface] \
    -v ~/.aMule:/home/amule/.aMule \
    -v ~/.aMule/Incoming:/incoming \
    -v ~/.aMule/Temp:/temp \
    paulchan/amule
```

This container:
- create amule configuration with PUID/PGID of amule users.
- use AmuleWebUI-Reloaded
- serve GUI/CMD at 4712
- serve Web UI at 4711, e.g. http://your-server:4711

Refer to wiki for more information:
- http://wiki.amule.org/wiki/Get_HighID
- https://en.wikipedia.org/wiki/AMule

## Run the container without configurations

If you don't have any existing amule configuration, you can specify a custom password for GUI and / or WebUI using adequate environment variables.

- To use amule GUI as interface :

```sh
docker run -d --name amule -p 4712:4712 -p 4662:4662 -p 4672:4672/udp \
    -e PUID=[wanted_uid] -e PGID=[wanted_gid] \
    -e GUI_PWD=[wanted_password_for_gui] \
    -v ./amule/conf:/home/amule/.aMule -v ./amule/incoming:/incoming -v ./amule/tmp:/temp amule-run
```

- To use web ui from a browser :

```sh
docker run -d --name amule -p 4711:4711 -p 4662:4662 -p 4672:4672/udp \
    -e PUID=[wanted_uid] -e PGID=[wanted_gid] \
    -e WEBUI_PWD=[wanted_password_for_web_interface] \
    -v ./amule/conf:/home/amule/.aMule -v ./amule/incoming:/incoming -v ./amule/tmp:/temp amule-run
```
## Run the container with existing amule configuration

Just mount existing directory as a volume :

```sh
docker run -d --name amule -p 4711:4711 -p 4662:4662 -p 4672:4672/udp \
    -e PUID=[wanted_uid] -e PGID=[wanted_gid] \
    -v ~/.aMule:/home/amule/.aMule -v ~/.aMule/Incoming:/incoming -v ~/.aMule/Temp:/temp amule-run
```

Then point your browser to http://localhost:4711 or http://your-server-name:4711

## Web UI theming

By default, this nice bootstrap based web theme is used (https://github.com/MatteoRagni/AmuleWebUI-Reloaded),
i.e. (-e WEBUI_TEMPLATE=AmuleWebUI-Reloaded).
This can be disabled by setting the environment variable _WEBUI_TEMPLATE_ to _default_

*Example* :

```sh
docker run -d --name amule -p 4711:4711 -p 4662:4662 -p 4672:4672/udp \
    -e PUID=[wanted_uid] -e PGID=[wanted_gid] \
    -e WEBUI_TEMPLATE=default \
    -v ~/.aMule:/home/amule/.aMule \
    -v ~/.aMule/Incoming:/incoming \
    -v ~/.aMule/Temp:/temp amule-run
```
