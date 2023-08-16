# kineticcafe/sqitch-pgtap Maintenance

Maintenance of kineticcafe/sqitch-pgtap is fairly easy but has some points worth
documenting.

On every release, remember to update the `opt/pgtap` cache files with `just
get-pgtap`.

## Updating Package Versions

Primary package versions are updated through `package-versions.json`. `pg_prove`
and `sqitch` can currently only be updated with releases; `pgtap` can be updated
with download versions or git references.

It is recommended that you use `just PACKAGE-set-version` to set new versions,
as this will maintain the required condensed format:

```sh
just sqitch-set-version 1.4.0
just pgtap-set-version 1.2.1
just pgtap-set-version 1.2.1 96a7a416311ea5f2fa140f59cfdf7c7afbded17c
just pgtap-set-hashref 96a7a416311ea5f2fa140f59cfdf7c7afbded17c
just pg_prove-set-version 3.36
```

Note that this file _must_ be condensed as it is passed as a JSON object in
GitHub Actions:

```sh
jq -c < package-versions.json | sponge package-versions.json
```

### Update `pg_prove`

To update `pg_prove`, update `pg_prove.version` in `package-versions.json`. That
version of `pg_prove` will be installed during the build of the Docker image.

```sh
just pg_prove-set-version 3.36
```

### Update `pgtap`

To update `pgtap`, update `pgtap.version` and/or `pgtap.hashref` in
`package-versions.json`. If `pgtap.hashref` is set, pgTAP will be updated from
git (from <https://github.com/theory/pgtap>). If omitted or empty, it will be
downloaded from [PGXN][].

```sh
just pgtap-set-version 1.2.1
just pgtap-set-version 1.2.1 96a7a416311ea5f2fa140f59cfdf7c7afbded17c
just pgtap-set-hashref 96a7a416311ea5f2fa140f59cfdf7c7afbded17c
```

The scripts and functions used by pgTAP vary by PostgreSQL version, so the
updated versions must be cached as `pgtap.tar`, which is committed to this repo.
This cache file can be updated with `just get-pgtap` (this requires
[casey/just][]).

### Update `sqitch`

To update `sqitch`, update `sqitch.version` in `package-versions.json`. That
version of `sqitch` will be installed during the build of the Docker image.

```sh
just sqitch-set-version 1.4.0
```

## Adding or Removing PostgreSQL Versions

PostgreSQL versions require updating in multiple places:

- `scripts/do_pgtap`: update the `version` case statement (lines 36–54) to add
  or remove a version pattern match.
- `build/pgtap/Dockerfile`:

  - Add or remove a `FROM` block for the appropriate version of PostgreSQL.
    These blocks are added in reverse order of version and we only specify
    _major_ PostgreSQL versions.

    ```dockerfile
    FROM postgres:<VERSION>-alpine3.<ALPINE_VERSION> AS build-pgtap-psql-<VERSION>

    ARG PGTAP_VERSION

    COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

    RUN apk add --no-cache --update perl wget postgresql-dev openssl \
          build-base make perl-dev bash \
        && mkdir -p /opt/pgtap/<VERSION> \
        && cd /opt/pgtap-$PGTAP_VERSION \
        && make && make install \
        && mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/<VERSION> \
        && rm -rf /var/cache/apk/* /tmp/*
    ```

    If adding support for a non-production version (such as `16beta2`), then the
    `FROM` line should look like this:

    ```dockerfile
    FROM postgres:16beta2-alpine3.18 AS build-pgtap-psql-16
    ```

    That is, the image name and pgtap folder name must be the major version
    number with no qualifiers.

  - Add a `COPY` line to the `package-pgtap` section:

    ```dockerfile
    COPY --from=build-pgtap-psql-<VERSION> /opt/pgtap/<VERSION> /opt/pgtap/<VERSION>
    ```

## Updating Docker Base Images

Docker base images must be kept up to date. These should be updated based on the
latest available Alpine version for each version of PostgreSQL used in
`build/pgtap/Dockerfile`, and the final release should be the latest available
Alpine version.

[pgxn]: https://pgxn.org/dist/pgtap
[casey/just]: https://github.com/casey/just
