# docker build -t phpmyadmin-fpm-alpine-caddy --build-arg BUILDKIT_INLINE_CACHE=1 -f ./docker/Dockerfile . && docker run --rm -it -p 8080:80 phpmyadmin-fpm-alpine-caddy
FROM alpine:3 as phpmyadmin-themes
WORKDIR /src/
RUN set -eux \
    && apk add --quiet --no-cache \
      curl \
      unzip \
    && curl -fsSL https://github.com/phpmyadmin/themes/archive/refs/heads/master.zip --output /src/phpmyadmin-themes.zip \
    && unzip -uoq /src/phpmyadmin-themes.zip -d /src/

ARG BASE_IMAGE_VERSION=latest
FROM phpmyadmin/phpmyadmin:${BASE_IMAGE_VERSION}

ENV TERM="xterm-256color" \
LANGUAGE="en_US.UTF-8" \
LANG="en_US.UTF-8" \
LC_TIME="en_DK.UTF-8" \
TIME_STYLE="long-iso"

RUN set -eux \
  && apk add --quiet --no-cache \
    iputils \
    # `fcgi` - Healthcheck |  https://github.com/renatomefi/php-fpm-healthcheck
    fcgi \
    tini

# Caddy | https://caddyserver.com/
COPY --from=caddy:2-alpine /usr/bin/caddy /usr/local/bin/caddy
COPY ./docker/config/caddy/Caddyfile /etc/caddy/Caddyfile
RUN set -eux \
#    && setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy \
    && caddy fmt --overwrite /etc/caddy/Caddyfile \
    && caddy version

# Healthcheck | https://github.com/renatomefi/php-fpm-healthcheck
RUN set -eux \
    && curl -fsSL https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck --output /usr/local/bin/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck \
    && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf
HEALTHCHECK --interval=1m --timeout=1s --start-period=10s CMD (curl --fail http://localhost/LICENSE && php-fpm-healthcheck) || exit 1

COPY ./docker/config/php-fpm.d/zzz-php-fpm_custom.conf /usr/local/etc/php-fpm.d/zzz-php-fpm_custom.conf

# Install themes
COPY --from=phpmyadmin-themes /src/themes-master/blueberry/ /var/www/html/themes/blueberry/
COPY --from=phpmyadmin-themes /src/themes-master/boodark/ /var/www/html/themes/boodark/

RUN set -eux \
    && rm -R themes/metro/ themes/bootstrap/ themes/original/

LABEL org.opencontainers.image.title="phpMyAdmin Docker image" \
    org.opencontainers.image.description="Run phpMyAdmin with Alpine, PHP FPM and Caddy" \
    org.opencontainers.image.authors="https://github.com/beeyev/phpmyadmin-docker-lightweight" \
    org.opencontainers.image.vendor="phpMyAdmin" \
    org.opencontainers.image.documentation="https://github.com/beeyev/phpmyadmin-docker-lightweight" \
    org.opencontainers.image.url="https://github.com/beeyev/phpmyadmin-docker-lightweight" \
    org.opencontainers.image.source="https://github.com/beeyev/phpmyadmin-docker-lightweight"

ARG TZ='UTC'
ENV TZ=$TZ

#These params meant to be set by CI
ARG BUILD_DATE
ENV BUILD_DATE=$BUILD_DATE
RUN echo $BUILD_DATE
ARG BUILD_FINGERPRINT
ENV BUILD_FINGERPRINT=$BUILD_FINGERPRINT
RUN echo $BUILD_FINGERPRINT

RUN set -eux \
    && mv /docker-entrypoint.sh /phpmyadmin-docker-entrypoint.sh

COPY --chmod=0755 ./docker/etc/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
EXPOSE 80

