FROM alpine:3.13 AS download

ENV PGTAP_VERSION=1.2.0-pre

# Until pgTAP 1.2 has been released, we need to use `git` to fix some issues
# with the extension-less install/uninstall method. Commenting out the `curl`
# version.

# RUN apk add curl \
#     && mkdir -p /opt && cd /opt \
#     && curl -sq -LO http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip \
#     && unzip pgtap-$PGTAP_VERSION.zip \
#     && apk del curl \
#     && rm -rf /var/cache/apk/* /tmp/*

RUN apk add git \
    && mkdir -p /opt && cd /opt \
    && git clone https://github.com/theory/pgtap.git pgtap-$PGTAP_VERSION \
    && apk del git \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:13-alpine AS build-pgtap-psql-13

ENV PGTAP_VERSION=1.2.0-pre

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/13 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/13 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:12-alpine as build-pgtap-psql-12

ENV PGTAP_VERSION=1.2.0-pre

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/12 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/12 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:11-alpine AS build-pgtap-psql-11

ENV PGTAP_VERSION=1.2.0-pre

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/11 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/11 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:10-alpine AS build-pgtap-psql-10

ENV PGTAP_VERSION=1.2.0-pre

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/10 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/10 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:9.6-alpine AS build-pgtap-psql-9

ENV PGTAP_VERSION=1.2.0-pre

COPY --from=download /opt/pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/9 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/9 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM alpine:3.13 AS build-pgtap

RUN mkdir -p /opt/pgtap

COPY --from=build-pgtap-psql-13 /opt/pgtap/13 /opt/pgtap/13
COPY --from=build-pgtap-psql-12 /opt/pgtap/12 /opt/pgtap/12
COPY --from=build-pgtap-psql-11 /opt/pgtap/11 /opt/pgtap/11
COPY --from=build-pgtap-psql-10 /opt/pgtap/10 /opt/pgtap/10
COPY --from=build-pgtap-psql-9 /opt/pgtap/9 /opt/pgtap/9

FROM alpine:3.13

ENV PGTAP_VERSION=1.2.0-pre \
      PGPROVE_VERSION=3.35 \
      SQITCH_VERSION=1.1.0

RUN apk add --no-cache --update perl postgresql-client perl-app-cpanminus tzdata \
        curl wget postgresql-dev openssl build-base make perl-dev bash nano less \
    && cpanm --quiet --notest \
        App::Sqitch@$SQITCH_VERSION \
        TAP::Parser::SourceHandler::pgTAP@$PGPROVE_VERSION \
        Template DBD::Pg \
    && adduser --disabled-password sqitch \
    && mkdir -p /opt /home/sqitch/bin \
    && apk del curl wget postgresql-dev build-base make perl-dev \
    && rm -rf /var/cache/apk/* /tmp/*

COPY --from=build-pgtap /opt/pgtap /opt/pgtap
COPY scripts/* /home/sqitch/bin
RUN chmod +x /home/sqitch/bin/* \
    && chown -R sqitch:sqitch /home

ENV LESS=-R LC_ALL=C.UTF-8 LANG=C.UTF-8 SQITCH_EDITOR=nano SQITCH_PAGER=less
USER sqitch

ENTRYPOINT []
