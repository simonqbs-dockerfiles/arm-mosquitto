FROM hypriot/rpi-alpine:3.5

ARG VCS_REF
ARG BUILD_DATE

LABEL \ 
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/simonqbs-dockerfiles/arm-mosquitto"

ENV MOSQUITTO_AUTH_PLUGIN_VERSION 0.1.1

RUN \
	apk add --no-cache mosquitto mosquitto-clients su-exec \
	&& cp /etc/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.dist.conf

COPY libressl.patch /build/

RUN \
	set -x; \
	apk add --update --virtual .build-deps build-base git mosquitto-dev \
	&& apk add sqlite-dev postgresql-dev libressl-dev \
	&& cd /build \
	&& git clone https://github.com/jpmens/mosquitto-auth-plug.git \
	&& cd mosquitto-auth-plug \
	&& git checkout $MOSQUITTO_AUTH_PLUGIN_VERSION \
	&& cp config.mk.in config.mk \
	&& patch cache.c /build/libressl.patch \
	&& make MOSQUITTO_SRC=/usr/lib BACKEND_MYSQL=no BACKEND_SQLITE=yes BACKEND_POSTGRES=yes \
	&& cp auth-plug.so /usr/local/lib/ \
	&& cp np /usr/local/bin/ \
	&& apk del .build-deps \
	&& rm -rf /build/mosquitto-auth-plug \
	&& rm -rf /var/lib/cache/apk

COPY mosquitto.conf /etc/mosquitto/
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME ["/var/lib/mosquitto"]

EXPOSE 1883 9001

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mosquitto", "-c", "/etc/mosquitto/mosquitto.conf"]
