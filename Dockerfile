FROM alpine:latest

ENV PGTAP_VERSION=1.1.0

RUN apk add --no-cache --update perl postgresql-client perl-app-cpanminus tzdata \
        curl wget postgresql-dev openssl build-base make perl-dev bash \
    && rm -rf /var/cache/apk/* /tmp/* \
    && cpanm --quiet --notest App::Sqitch Template DBD::Pg TAP::Parser::SourceHandler::pgTAP \
    && addgroup -S sqitcher \
    && adduser -S sqitcher -G sqitcher \
    && cd /tmp \
    && curl -sq -LO http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip \
    && unzip pgtap-$PGTAP_VERSION.zip \
    && cd pgtap-$PGTAP_VERSION \
    && make \
    && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /home/sqitcher \
    && cd / \
    && mkdir -p /home/sqitcher/bin \
    && apk del curl wget postgresql-dev build-base make perl-dev \
    && rm -rf /var/cache/apk/* /tmp/*

COPY scripts/* /home/sqitcher/bin
RUN chmod +x /home/sqitcher/bin/* \
    && chown sqitcher:sqitcher -R /home/sqitcher

USER sqitcher

ENTRYPOINT []
