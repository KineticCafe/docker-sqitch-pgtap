# kineticcafe/sqitch-pgtap Maintenance

Maintenance of kineticcafe/sqitch-pgtap is fairly easy but has some points worth
documenting. Release maintenance is managed with [casey/just][] and require
[sponge][], [jq][], and [docker][].

## Updating Package Versions

Package versions are managed in `package-versions.json` with just recipes to
ensure that the values are correctly updated.

### `just version`

This recipe prints the current version of all packages, approximating what
`kineticcafe-sqitch-pgtap version` without building or running the image.

```console
$ just version
[gchr.io/]kineticcafe/sqitch-pgtap:2.6.1

  alpine 3.19
  sqitch (App::Sqitch) v1.4.1
  pgtap 1.3.3
  pg_prove 3.36

Last updated 2024-04-22
```

### `just version VERSION`

This recipe prints the current version of all packages and then updates the
image version and date.

```console
$ just version 2.6.1
[gchr.io/]kineticcafe/sqitch-pgtap:2.6.0

  alpine 3.19
  sqitch (App::Sqitch) v1.4.1
  pgtap 1.3.3
  pg_prove 3.36

Last updated null

- VERSION :: 2.6.0
+ VERSION :: 2.6.1
- DATE :: null
+ DATE :: 2024-04-22

[gchr.io/]kineticcafe/sqitch-pgtap:2.6.1

  alpine 3.19
  sqitch (App::Sqitch) v1.4.1
  pgtap 1.3.3
  pg_prove 3.36

Last updated 2024-04-22
```

### `just sqitch VERSION`

Sets the desired [Sqitch][] version to `VERSION`. Sqitch will be installed from
[CPAN][] during the build of the Docker image.

```console
$ just sqitch 1.4.1
- sqitch.version :: 1.4.0
+ sqitch.version :: 1.4.1
- DATE :: 2023-08-03
+ DATE :: 2024-02-27
```

### `just pgtap VERSION [HASHREF]`

Sets the desired [pgTAP][] version to `VERSION`. pgTAP will be installed from
[PGXN][] during the refresh of the pgTAP scripts in `opt/...`.

If a pre-release version is required, the full `HASHREF` of must be provided to
use that version from <https://github.com/theory/pgtap>. Only pre-release
commits on the `main` branch should be used.

```console
$ just pgtap 1.3.3 96a7a416311ea5f2fa140f59cfdf7c7afbded17c
- pgtap.version :: 1.3.2
+ pgtap.version :: 1.3.3
- pgtap.hashref :: null
+ pgtap.hashref :: 96a7a416311ea5f2fa140f59cfdf7c7afbded17c

$ just pgtap 1.3.3
- pgtap.version :: 1.3.3
+ pgtap.version :: 1.3.3
- pgtap.hashref :: 96a7a416311ea5f2fa140f59cfdf7c7afbded17c
```

If a version change is detected, [`just update-pgtap`](#just-update-pgtap) will
be run.

### `just pg_prove VERSION`

Sets the desired [`pg_prove`][] version to `VERSION`. `pg_prove` will be
installed from [CPAN][] during the build of the Docker image.

```console
$ just pg_prove 3.36
- pg_prove.version :: 3.35
+ pg_prove.version :: 3.36
```

### `just alpine VERSION`

Updates the base Docker image for use with the main `Dockerfile` and for
`build/pgtap/versions.json` from which the pgTAP image is generated (used in
`just update-pgtap`). Updating this version will automatically run
[`just update-pgtap`](#just-update-pgtap).

```console
$ just alpine 3.19
- alpine.version :: 3.18
+ alpine.version :: 3.19
```

### `just postgres VERSION [using NAME] [alpine ALPINE_VERSION]`

Adds or updates a PostgreSQL version specification for pgTAP in
`build/pgtap/versions.json`. It can be used to:

1. Add a new pre-release version of PostgreSQL:

   ```console
   $ just postgres 17 using 17beta1
   # Inserts PostgreSQL 17 beta 1 as version 17
   ```

2. Add a release version of PostgreSQL or update a pre-release version to
   released:

   ```console
   # just postgres 17
   # Updates PostgreSQL 17 to use the latest release
   ```

3. Force a version of PostgreSQL to a specific version of Alpine. This is
   required when the PostgreSQL version has reached end of life and no longer
   receives builds on newer versions of Alpine.

   ```console
   $ just postgres 11 alpine 3.19
   # Updates PostgreSQL 11 to use Alpine 3.19
   ```

4. Mark a version of PostgreSQL as end of life.

   ```console
   $ just postgres 11 eol 2023-11-06
   # Updates PostgreSQL 11 to be considered EOL as of the provided date
   ```

If changing an already existing version, remember to include all attributes that
should be kept or they will be erased. The current attributes can be found by
prepending `=` to the version:

```console
$ just postgres =9.6
{
  "name": "9.6",
  "alpine": "3.15",
  "eol": "2021-11-11"
}
$ just postgres =17
# The output is blank because PostgreSQL 17 is not yet available.
```

Updating this version will automatically update `scripts/do_pgtap` and run
[`just update-pgtap`](#just-update-pgtap).

### `just update-pgtap`

This recipe will _usually_ be run automatically after Alpine, PostgreSQL, or
pgTAP changes. If a manual rebuild of the cached pgTAP artifacts is required,
call this recipe.

[`pg_prove`]: https://pgtap.org/pg_prove.html
[casey/just]: https://github.com/casey/just
[cpan]: https://www.cpan.org
[docker]: https://www.docker.com
[jq]: https://jqlang.github.io/jq/
[pgtap]: https://pgtap.org
[pgxn]: https://pgxn.org/dist/pgtap
[sponge]: https://joeyh.name/code/moreutils/
[sqitch]: https://sqitch.org
