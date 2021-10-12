# Docker Image for BuildKite CI
# -----------------------------

FROM node:10.20

MAINTAINER vin <vin@misday.com>

ARG VERSION=3.2.3

LABEL version=$VERSION

RUN apt-get update && \
    apt-get -y install calibre && \
    npm install --global gitbook-cli && \
    gitbook fetch ${VERSION} && \
    npm cache clear && \
    rm -rf /tmp/*

WORKDIR /srv/gitbook

VOLUME /srv/gitbook /srv/html

EXPOSE 4000 35729

CMD /usr/local/bin/gitbook serve
