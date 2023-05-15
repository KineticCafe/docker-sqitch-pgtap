FROM alpine:3.18

ARG PG_PROVE_VERSION
ARG PGTAP_VERSION
ARG SQITCH_VERSION

ENV __DOCKERFILE_VERSION__=2.1.0

RUN apk update \
    && apk add --no-cache --update \
        build-base \
        curl \
        make \
        perl-dev \
        postgresql-dev \
        wget \
    && apk add --no-cache --update \
        bash \
        jq \
        less \
        nano \
        openssl \
        perl \
        perl-app-cpanminus \
        postgresql-client \
        tzdata \
    && cpanm --quiet --notest --no-man-pages \
        App::Sqitch@$SQITCH_VERSION \
        TAP::Parser::SourceHandler::pgTAP@$PG_PROVE_VERSION \
        Template DBD::Pg \
    && adduser --disabled-password sqitch \
    && mkdir -p /opt /home/sqitch/bin \
    && echo $__DOCKERFILE_VERSION__ > /home/sqitch/VERSION \
    && apk del \
        build-base \
        curl \
        make \
        perl-dev \
        postgresql-dev \
        wget \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cpanm

COPY opt/pgtap /opt/pgtap/
COPY scripts/* /home/sqitch/bin/
COPY package-versions.json /home/sqitch/
RUN chmod +x /home/sqitch/bin/* \
    && chown -R sqitch:sqitch /home

ENV LESS=-R LC_ALL=C.UTF-8 LANG=C.UTF-8 SQITCH_EDITOR=nano SQITCH_PAGER=less
USER sqitch

ENTRYPOINT []
