#!/bin/sh
# Entrypoint file based on what docker's official images are using.
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- mosquitto "$@"
fi

if [ "$1" = 'mosquitto' -a "$(id -u)" = '0' ]; then
	chown -Rf mosquitto /etc/mosquitto /var/lib/mosquitto
	exec su-exec mosquitto "$0" "$@"
fi

exec "$@"
