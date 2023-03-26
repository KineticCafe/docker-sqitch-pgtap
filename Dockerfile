ARG PGPROVE_VERSION=3.36
ARG SQITCH_VERSION=1.3.1
ARG PGTAP_VERSION=1.2.1

ARG PGTAP_VERSION_HASHREF=56c591fc3bf6b2dba49e15739625916d49e3fc27
ARG PGTAP_DOWNLOAD

FROM alpine:3.17 AS download

ARG PGTAP_VERSION
ARG PGTAP_VERSION_HASHREF
ARG PGTAP_DOWNLOAD

RUN apk add curl git \
    && mkdir -p /opt && cd /opt \
    && if [ $PGTAP_DOWNLOAD = 1 ]; then \
         curl -sq -LO \
            http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip \
         && unzip pgtap-$PGTAP_VERSION.zip; \
       else \
        git clone \
            https://github.com/theory/pgtap.git pgtap-$PGTAP_VERSION \
        && cd /opt/pgtap-$PGTAP_VERSION \
        && git switch --detach $PGTAP_VERSION_HASHREF; \
    fi

FROM postgres:15-alpine3.17 AS build-pgtap-psql-15

ARG PGTAP_VERSION

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/15 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/15 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:14-alpine3.17 AS build-pgtap-psql-14

ARG PGTAP_VERSION

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/14 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/14 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:13-alpine3.17 AS build-pgtap-psql-13

ARG PGTAP_VERSION

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/13 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/13 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:12-alpine3.17 as build-pgtap-psql-12

ARG PGTAP_VERSION

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/12 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/12 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:11-alpine3.17 AS build-pgtap-psql-11

ARG PGTAP_VERSION

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/11 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/11 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:10-alpine3.16 AS build-pgtap-psql-10

ARG PGTAP_VERSION

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/10 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/10 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM alpine:3.17 AS build-pgtap

ARG PGTAP_VERSION

RUN mkdir -p /opt/pgtap

COPY --from=build-pgtap-psql-15 /opt/pgtap/15 /opt/pgtap/15
COPY --from=build-pgtap-psql-14 /opt/pgtap/14 /opt/pgtap/14
COPY --from=build-pgtap-psql-13 /opt/pgtap/13 /opt/pgtap/13
COPY --from=build-pgtap-psql-12 /opt/pgtap/12 /opt/pgtap/12
COPY --from=build-pgtap-psql-11 /opt/pgtap/11 /opt/pgtap/11
COPY --from=build-pgtap-psql-10 /opt/pgtap/10 /opt/pgtap/10

FROM alpine:3.17

ARG PGPROVE_VERSION
ARG PGTAP_VERSION
ARG SQITCH_VERSION

ENV __DOCKERFILE_VERSION__=1.2.1

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
        TAP::Parser::SourceHandler::pgTAP@$PGPROVE_VERSION \
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
