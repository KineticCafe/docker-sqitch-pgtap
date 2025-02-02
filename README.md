# [ghcr.io/]kineticcafe/sqitch-pgtap: Sqitch/PostgreSQL & pgTAP in Docker

> [!IMPORTANT]
>
> This image will no longer receive updates and the repo is being archived as we
> no longer use Sqitch or pgTAP. I recommend forking this repo if you wish to
> maintain a similar image for your organization as the architecture and actions
> work very well.
>
> Kinetic Cafe open source team

This is a simple Docker container that contains [sqitch][sqitch],
[pgTAP][pgTAP], and [`pg_prove`][`pg_prove`] for use with PostgreSQL. It has
been created so that it's easier to work with `sqitch` and `pg_prove`/`pgTAP`
without going through the effort of installing them on various systems.

The image is based on Alpine 3.19 and does not include a PostgreSQL server;
instead, it is expected that all values will be provided through environment
variables or on the command-line.

Unless otherwise noted, pgTAP will be installed from [PGXN][PGXN].

This version of the container includes:

- pgTAP 1.3.3 (from theory/pgtap@02bc769c92c48d01e4c2f76db6523287017b45a9)
  - Full support for PostgreSQL 12, 13, 14, 15, 16, and 17
  - Best effort support for end of life PostgreSQL versions 9.6, 10, 11, and 12
- pg\_prove 3.36
- Sqitch 1.5.0

The version of pgTAP is installed and uninstalled as needed; unit test files
_**must not**_ include `CREATE EXTENSION pgtap`.

These images can be pulled either from Docker Hub
(`kineticcafe/sqitch-pgtap:2.7`) or the GitHub Container Registry
(`ghcr.io/kineticcafe/sqitch-pgtap:2.7`).

## `kineticcafe-sqitch-pgtap` script Commands

The `kineticcafe-sqitch-pgtap` script is recommended for running everything as
it manages environment variable configuration for each run. The
`kineticcafe-sqitch-pgtap` script will pull from
`ghcr.io/kineticcafe/sqitch-pgtap:2` by default; this can be overridden by using
`$IMAGE`:

```console
$ IMAGE=kineticcafe/sqitch-pgtap:latest ./run version
[gchr.io/]kineticcafe/sqitch-pgtap:2.10.0

  alpine 3.21
  sqitch (App::Sqitch) v1.5.0
  pgtap 1.3.3
  pg_prove 3.36

Last updated 2025-01-07
```

### Installing `kineticcafe-sqitch-pgtap`

`kineticcafe-sqitch-pgtap` can be installed with symlinks using the `install`
script:

```sh
curl -sSL --fail \
  https://raw.githubusercontent.com/KineticCafe/docker-sqitch-pgtap/main/install |
  bash -s -- ~/.local/bin
```

Replace `~/.local/bin` with your preferred binary directory.

By default, it will download `kineticcafe-sqitch-pgtap` from GitHub and install
it in the provided `TARGET` and make symbolic links for the following commands:
`sqitch`, `sqitcher`, and `pgtap`. Symbolic link creation will not overwrite
files or symbolic links to locations _other_ than `TARGET/kinetic-sqitch-pgtap`.

`sqitcher` is a shorter name for `kineticcafe-sqitch-pgtap`.

`--no-symlinks` (`-S`) may be specified to skip symbolic link creation entirely.

`--force` (`-f`) may be specified to install `kineticcafe-sqitch-pgtap` even if
it already exists, and to overwrite files and
non-`TARGET/kineticcafe-sqitch-pgtap` symbolic links.

`--verbose` (`-v`) will turn on trace output of commands.

### Core commands

- `sqitch`: Runs Sqitch
- `pg_prove`: Runs `pg_prove` directly
- `pgtap install`: Installs pgTAP in the current database
- `pgtap uninstall`: Uninstalls pgTAP from the current database
- `pgtap test`: Installs pgTAP, runs `pg_prove`, and then uninstalls pgTAP
- `version`: Prints the versions of the applications

### PostgreSQL commands

- `createdb`
- `dropdb`
- `psql`
- `pg_config`
- `pg_controldata`
- `pg_ctl`
- `pg_archivecleanup`
- `pg_basebackup`
- `pg_dump`
- `pg_dumpall`
- `pg_restore`
- `pg_isready`
- `pg_standby`
- `pg_test_fsync`
- `pg_test_timing`
- `pg_recvlogical`
- `pg_rewind`
- `pg_upgrade`
- `pg_receivexlog`
- `pg_resetxlog`
- `pg_xlogdump`

### Extra commands

- `sh`: Start a shell in the image
- `jq`: Runs jq
- `nano`: Runs nano
- `show-targets`: Shows configured sqitch targets
- `show-default-target`: Shows the configured default target
- `show-default-dbname`: Shows the configured default target database name
- `pgtap-tests`: Runs `pgtap test test/*.sql` for the default database

[`pg_prove`]: https://pgtap.org/pg_prove.html
[pgtap]: https://pgtap.org
[pgxn]: https://pgxn.org/dist/pgtap/
[sqitch]: https://sqitch.org
[theory/tap-parser-sourcehandler-pgtap]: https://github.com/theory/tap-parser-sourcehandler-pgtap
