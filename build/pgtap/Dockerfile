FROM postgres:15-alpine3.17 AS build-pgtap-psql-15

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/15 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/15 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:14-alpine3.17 AS build-pgtap-psql-14

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/14 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/14 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:13-alpine3.17 AS build-pgtap-psql-13

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/13 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/13 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:12-alpine3.17 as build-pgtap-psql-12

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/12 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/12 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:11-alpine3.17 AS build-pgtap-psql-11

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/11 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/11 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:10-alpine3.16 AS build-pgtap-psql-10

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/10 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/10 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM postgres:9.6-alpine3.15 AS build-pgtap-psql-9.6

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN apk add --no-cache --update perl wget postgresql-dev openssl \
        build-base make perl-dev bash \
    && mkdir -p /opt/pgtap/9.6 \
    && cd /opt/pgtap-$PGTAP_VERSION \
    && make && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/9.6 \
    && rm -rf /var/cache/apk/* /tmp/*

FROM alpine:3.17 AS package-pgtap

ARG PGTAP_VERSION

RUN mkdir -p /opt/pgtap

COPY --from=build-pgtap-psql-15 /opt/pgtap/15 /opt/pgtap/15
COPY --from=build-pgtap-psql-14 /opt/pgtap/14 /opt/pgtap/14
COPY --from=build-pgtap-psql-13 /opt/pgtap/13 /opt/pgtap/13
COPY --from=build-pgtap-psql-12 /opt/pgtap/12 /opt/pgtap/12
COPY --from=build-pgtap-psql-11 /opt/pgtap/11 /opt/pgtap/11
COPY --from=build-pgtap-psql-10 /opt/pgtap/10 /opt/pgtap/10
COPY --from=build-pgtap-psql-9.6 /opt/pgtap/9.6 /opt/pgtap/9.6

RUN tar cf /opt/pgtap.tar /opt/pgtap
