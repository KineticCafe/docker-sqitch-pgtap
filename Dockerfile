FROM alpine:latest

ENV PGTAP_VERSION=1.1.0

RUN apk add --no-cache --update perl postgresql-client perl-app-cpanminus tzdata \
        curl wget postgresql-dev openssl build-base make perl-dev bash nano less \
    && rm -rf /var/cache/apk/* /tmp/* \
    && cpanm --quiet --notest App::Sqitch Template DBD::Pg TAP::Parser::SourceHandler::pgTAP \
    && addgroup -S sqitch \
    && adduser -S sqitch -G sqitch \
    && cd /tmp \
    && curl -sq -LO http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip \
    && unzip pgtap-$PGTAP_VERSION.zip \
    && cd pgtap-$PGTAP_VERSION \
    && make \
    && make install \
    && mv sql/pgtap.sql sql/uninstall_pgtap.sql /home/sqitch \
    && cd / \
    && mkdir -p /home/sqitch/bin \
    && apk del curl wget postgresql-dev build-base make perl-dev \
    && rm -rf /var/cache/apk/* /tmp/*

COPY scripts/* /home/sqitch/bin
RUN chmod +x /home/sqitch/bin/* \
    && chown -R sqitch:sqitch /home

ENV LESS=-R LC_ALL=C.UTF-8 LANG=C.UTF-8 SQITCH_EDITOR=nano SQITCH_PAGER=less
USER sqitch

ENTRYPOINT []
