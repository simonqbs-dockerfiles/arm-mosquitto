# simonqbs/arm-mosquitto

[![build status](https://gitlab.com/simonqbs-dockerfiles/arm-mosquitto/badges/master/build.svg)](https://gitlab.com/simonqbs-dockerfiles/arm-mosquitto/commits/master)
[![](https://images.microbadger.com/badges/image/simonqbs/arm-mosquitto.svg)](https://microbadger.com/images/simonqbs/arm-mosquitto "Get your own image badge on microbadger.com")


This is a docker image for running [mosquitto](https://mosquitto.org) in a docker container on
an arm(hf) based system. Comes bundled with [mosquitto-auth-plug](https://github.com/jpmens/mosquitto-auth-plug) with postgresql and sqlite backend support.  
  
Currently only tested on a Raspberry Pi 3 running on Arch Linux.

## Usage

Here's an example to get you started.

**Run the server**

```
docker run --rm --name mosquitto -p 1883:1883 simonqbs/rpi-mosquitto
```

**Subscribe to `hello` topic**

```
docker run -it --rm --link mosquitto:mosquitto simonqbs/rpi-mosquitto mosquitto_sub -h mosquitto -t hello
```

**Publish to `hello` topic**

```
docker run --rm --link mosquitto:mosquitto simonqbs/rpi-mosquitto mosquitto_pub -h mosquitto -t hello -m world
```

## Configuration

Default configuration file is located at `/etc/mosquitto/mosquitto.conf` which
can be overriden with `docker run -v /path/to/mosquitto.conf:/etc/mosquitto/mosquitto.conf ...` for example.

## Credits

* LibreSSL patch was inspired from the Alpine Linux [mosquitto package](http://git.alpinelinux.org/cgit/aports/tree/main/mosquitto/libressl.patch).
