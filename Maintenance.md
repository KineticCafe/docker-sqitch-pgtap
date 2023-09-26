# kineticcafe/sqitch-pgtap Maintenance

Maintenance of kineticcafe/sqitch-pgtap is fairly easy but has some points worth
documenting.

On every release, remember to update the `opt/pgtap` cache files with `just
update-pgtap`.

## Updating Package Versions

Primary package versions are updated through `package-versions.json`. `pg_prove`
and `sqitch` can currently only be updated with releases; `pgtap` can be updated
with download versions or git references.

It is recommended that you use `just PACKAGE-set-version` to set new versions,
as this will maintain the required condensed format:

```sh
just alpine-set-version 3.18
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
This cache file can be updated with `just update-pgtap` (this requires
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
- `build/pgtap/versions.json`:

  - If the base version of Alpine is being changed, update `defaults.alpine`.
    This is done automatically by `just alpine-set-version`

  - Add or remove a block in the `postgres` array. The only required parameter
    is `name`, which should be the short version name.

    - If an alternative (older) version of Alpine is required, set the parameter
      `alpine` to the required version.

    - When adding a beta version, add a `version` key with the required version.
      For 17beta1, the block would look like:

      ```json
      { "name": "17", "version": "17beta1" }
      ```

The `build/pgtap/Dockerfile` will be updated automatically based on
`build/pgtap/versions.json`.

## Updating Docker Base Images

Docker base images must be kept up to date, and this is managed through
`package-versions.json`.

```sh
just alpine-set-version 3.18
```

[pgxn]: https://pgxn.org/dist/pgtap
[casey/just]: https://github.com/casey/just
