# syntax=docker/dockerfile:1

FROM postgres:17-alpine3.20 AS build-pgtap-psql-17

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/17
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/17
BUILD


FROM postgres:16-alpine3.20 AS build-pgtap-psql-16

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/16
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/16
BUILD


FROM postgres:15-alpine3.20 AS build-pgtap-psql-15

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/15
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/15
BUILD


FROM postgres:14-alpine3.20 AS build-pgtap-psql-14

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/14
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/14
BUILD


FROM postgres:13-alpine3.20 AS build-pgtap-psql-13

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/13
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/13
BUILD


FROM postgres:12-alpine3.20 AS build-pgtap-psql-12

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/12
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/12
BUILD


FROM postgres:11-alpine3.19 AS build-pgtap-psql-11

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/11
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/11
BUILD


FROM postgres:10-alpine3.16 AS build-pgtap-psql-10

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/10
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/10
BUILD


FROM postgres:9.6-alpine3.15 AS build-pgtap-psql-9.6

ARG PGTAP_VERSION

COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

RUN <<SETUP
set -eux

apk update

apk add \
  bash \
  build-base \
  make \
  openssl \
  perl \
  perl-dev \
  postgresql-dev \
  wget

wanted_clang=$(
  pg_config --configure |
    tr ' ' '\n' |
    grep CLANG |
    sed "s/'CLANG=\(.*\)'/\1/"
)

if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
  version="${wanted_clang/clang-}"
  apk add clang"${version}" llvm"${version}"
fi

mkdir -p /opt/pgtap/9.6
SETUP

RUN <<BUILD
set -eux

cd /opt/pgtap-$PGTAP_VERSION
make
make install
mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/9.6
BUILD


FROM alpine:3.21 AS package-pgtap

RUN mkdir -p /opt/pgtap

COPY --from=build-pgtap-psql-17 /opt/pgtap/17 /opt/pgtap/17
COPY --from=build-pgtap-psql-16 /opt/pgtap/16 /opt/pgtap/16
COPY --from=build-pgtap-psql-15 /opt/pgtap/15 /opt/pgtap/15
COPY --from=build-pgtap-psql-14 /opt/pgtap/14 /opt/pgtap/14
COPY --from=build-pgtap-psql-13 /opt/pgtap/13 /opt/pgtap/13
COPY --from=build-pgtap-psql-12 /opt/pgtap/12 /opt/pgtap/12
COPY --from=build-pgtap-psql-11 /opt/pgtap/11 /opt/pgtap/11
COPY --from=build-pgtap-psql-10 /opt/pgtap/10 /opt/pgtap/10
COPY --from=build-pgtap-psql-9.6 /opt/pgtap/9.6 /opt/pgtap/9.6

RUN tar cf /opt/pgtap.tar /opt/pgtap
