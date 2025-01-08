# syntax=docker/dockerfile:1

ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION

ARG PG_PROVE_VERSION
ARG PGTAP_VERSION
ARG SQITCH_VERSION
ARG __DOCKERFILE_VERSION__
ARG __DOCKERFILE_DATE__

# hadolint ignore=DL3018,DL3019
RUN <<SETUP
set -eux

apk update

apk add \
      bash \
      build-base \
      curl \
      jq \
      less \
      make \
      nano \
      openssl \
      perl \
      perl-app-cpanminus \
      perl-dev \
      postgresql-client \
      postgresql-dev \
      tzdata \
      wget

cpanm --quiet --notest --no-man-pages \
      App::Sqitch@$SQITCH_VERSION \
      TAP::Parser::SourceHandler::pgTAP@$PG_PROVE_VERSION \
      Template \
      DBD::Pg

apk del \
      build-base \
      curl \
      make \
      perl-dev \
      postgresql-dev \
      wget

rm -rf /var/cache/apk/* /tmp/* /root/.cpanm
SETUP

COPY opt/pgtap /opt/pgtap/
COPY scripts/* /home/sqitch/bin/
COPY package-versions.json /home/sqitch/

RUN <<FINALIZE
set -eux

adduser --disabled-password sqitch
mkdir -p /opt /home/sqitch/bin

echo $__DOCKERFILE_VERSION__ > /home/sqitch/VERSION
echo $__DOCKERFILE_DATE__ > /home/sqitch/DATE

chmod +x /home/sqitch/bin/*
chown -R sqitch:sqitch /home/sqitch
FINALIZE

ENV LESS=-R LC_ALL=C.UTF-8 LANG=C.UTF-8 SQITCH_EDITOR=nano SQITCH_PAGER=less
USER sqitch

ENTRYPOINT []
