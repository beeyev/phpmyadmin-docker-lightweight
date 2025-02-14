# syntax=docker/dockerfile:1
# Author: Alexander Tebiev - https://github.com/beeyev/phpmyadmin-docker-lightweight
# docker buildx build --build-arg=BASE_IMAGE_VERSION=5.2-fpm-alpine --cache-to=type=inline --pull --tag phpmyadmin-fpm-alpine-caddy --file ./docker/Dockerfile ./ && docker run -p 9090:80 -it --rm phpmyadmin-fpm-alpine-caddy
ARG BASE_IMAGE_VERSION
FROM phpmyadmin:${BASE_IMAGE_VERSION} AS phpmyadmin

FROM alpine:3 AS phpmyadmin-themes
WORKDIR /src/
RUN set -eux \
    && apk add --quiet --no-cache \
      curl \
      unzip \
    && curl -fsSL https://github.com/phpmyadmin/themes/archive/refs/heads/master.zip --output /src/phpmyadmin-themes.zip \
    && unzip -uoq /src/phpmyadmin-themes.zip -d /src/ \
    && mkdir /src/selected-themes/ \
    && cp -r /src/themes-master/blueberry/ /src/themes-master/boodark/ -t /src/selected-themes/


FROM phpmyadmin

ENV TERM="xterm-256color" \
LANGUAGE="en_US.UTF-8" \
LANG="en_US.UTF-8" \
LC_TIME="en_DK.UTF-8" \
TIME_STYLE="long-iso"

RUN --mount=type=cache,sharing=locked,target=/var/cache/apk/ set -eux \
  && apk add --quiet --update --no-cache \
    iputils \
    # `fcgi` - Healthcheck |  https://github.com/renatomefi/php-fpm-healthcheck
    fcgi \
    tini

# Caddy | https://caddyserver.com/
COPY --from=caddy:2-alpine /usr/bin/caddy /usr/local/bin/caddy
COPY ./docker/config/caddy/Caddyfile /etc/caddy/Caddyfile
ENV ACME_AGREE=true
RUN set -eux \
    && caddy validate --config /etc/caddy/Caddyfile \
    && caddy version

## Healthcheck |  https://github.com/renatomefi/php-fpm-healthcheck
ADD --chmod=0705 --link https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck /usr/local/bin/php-fpm-healthcheck
RUN set -eux \
    && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf
# Cheching Caddy & php-fpm
HEALTHCHECK --interval=1m --timeout=1s --start-period=10s CMD (curl --fail http://localhost:9999/health && php-fpm-healthcheck) || exit 1

COPY ./docker/config/php-fpm.d/zzz-php-fpm_custom.conf /usr/local/etc/php-fpm.d/zzz-php-fpm_custom.conf

# Install themes
COPY --from=phpmyadmin-themes /src/selected-themes/ /var/www/html/themes/

LABEL org.opencontainers.image.title="phpMyAdmin Docker image" \
    org.opencontainers.image.description="Run phpMyAdmin with Alpine, PHP FPM and Caddy" \
    org.opencontainers.image.authors="https://github.com/beeyev/" \
    org.opencontainers.image.vendor="phpMyAdmin" \
    org.opencontainers.image.documentation="https://github.com/beeyev/phpmyadmin-docker-lightweight" \
    org.opencontainers.image.url="https://github.com/beeyev/phpmyadmin-docker-lightweight" \
    org.opencontainers.image.source="https://github.com/beeyev/phpmyadmin-docker-lightweight"

ARG TZ='UTC'
ENV TZ=$TZ

#These params meant to be set by CI
ARG BUILD_DATE=undefined
ENV BUILD_DATE=$BUILD_DATE
RUN echo $BUILD_DATE
ARG BUILD_FINGERPRINT=undefined
ENV BUILD_FINGERPRINT=$BUILD_FINGERPRINT
RUN echo $BUILD_FINGERPRINT
ARG BRANCH_NAME=undefined
ENV BRANCH_NAME=$BRANCH_NAME
RUN echo $BRANCH_NAME

RUN set -eux \
    && mv /docker-entrypoint.sh /phpmyadmin-docker-entrypoint.sh

COPY --chmod=0755 ./docker/etc/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
EXPOSE 80
