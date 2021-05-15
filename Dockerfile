FROM alpline:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ENV PGTAP_VERSION=1.1.0

RUN apk add --no-cache --update perl postgresql-client perl-app-cpanminus \
        curl postgresql-dev openssl build-base make perl-dev bash \
    && rm -rf /var/cache/apk/* /tmp/* \
    && cpanm --quiet --notest App:Sqitch Template DBD::Pg TAP::Parser::SourceHandler::pgTAP \
    && cd /tmp \
    && curl -sq -LO http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip \
    && unzip pgtap-$PGTAP_VERSION.zip \
    && cd pgtap-$PGTAP_VERSION \
    && make \
    && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql / \
    && cd / \
    && apk del curl postgresql-dev git build-base make perl-dev bash \
    && rm -rf /var/cache/apk/* /tmp/* \
    && addgroup -S sqitcher \
    && adduser -S sqitcher -G sqitcher

USER sqitcher

COPY scripts/* /home/sqitcher/bin
RUN chmod +x /home/sqitcher/bin/*

ENTRYPOINT []

LABEL org.label-scheme.build-date=$BUILD_DATE \
      org.label-schema.name="kineticcafe/sqitch-pgtap" \
      org.label-schema.description="PostgreSQL sqitch & pgTAP" \
      org.label-schema.url="https://github.com/KineticCafe/docker-sqitch-pgtap" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/KineticCafe/docker-sqitch-pgtap" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version="$VERSION" \
      org.label-schema.vendor="Kinetic Cafe" \
      org.label-schema.license="MIT" \
      org.label-schema.docker.dockerfile="Dockerfile" \
      org.label-schema.schema-version="1.0"
