FROM alpine:3.17 AS build-pgtap

COPY pgtap.tar /tmp

RUN tar xf /tmp/pgtap.tar

FROM alpine:3.17

ARG PG_PROVE_VERSION
ARG PGTAP_VERSION
ARG SQITCH_VERSION

ENV __DOCKERFILE_VERSION__=2.1.0

RUN apk add --no-cache --update \
        build-base \
        curl \
        wget \
        perl-dev \
        postgresql-dev \
        make \
    && apk add --no-cache --update \
        bash \
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
    && apk del curl wget postgresql-dev build-base make perl-dev \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cpanm

COPY --from=build-pgtap /opt/pgtap /opt/pgtap
COPY scripts/* /home/sqitch/bin/
RUN chmod +x /home/sqitch/bin/* \
    && chown -R sqitch:sqitch /home

ENV LESS=-R LC_ALL=C.UTF-8 LANG=C.UTF-8 SQITCH_EDITOR=nano SQITCH_PAGER=less
USER sqitch

ENTRYPOINT []
