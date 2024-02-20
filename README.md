# [ghcr.io/]kineticcafe/sqitch-pgtap: Sqitch/PostgreSQL & pgTAP in Docker

This is a simple Docker container that contains [sqitch][], [pgTAP][], and
[`pg_prove`][] for use with PostgreSQL. It has been created so that it's easier
to work with `sqitch` and `pg_prove`/`pgTAP` without going through the effort of
installing them on various systems.

The image is based on Alpine 3.18 and does not include a PostgreSQL server;
instead, it is expected that all values will be provided through environment
variables or on the command-line.

Unless otherwise noted, pgTAP will be installed from [PGXN][].

This version of the container includes:

- pgTAP 1.3.3 (from theory/pgtap@02bc769c92c48d01e4c2f76db6523287017b45a9)
  - Support for PostgreSQL 9.6, 10, 11, 12, 13, 14, 15, and 16
- pg_prove 3.36
- Sqitch 1.4.0

The version of pgTAP is installed and uninstalled as needed; unit test files
_**must not**_ include `CREATE EXTENSION pgtap`.

These images can be pulled either from Docker Hub
(`kineticcafe/sqitch-pgtap:2.4`) or the GitHub Container Registry
(`ghcr.io/kineticcafe/sqitch-pgtap:2.4`).

## `run` script Commands

The `run` script is recommended for running everything as it manages environment
variable configuration for each run. The `run` script will pull from
`ghcr.io/kineticcafe/sqitch-pgtap:2` by default; this can be overridden by
using `$IMAGE`:

```console
$ IMAGE=kineticcafe/sqitch-pgtap:latest ./run version
[gchr.io/]kineticcafe/sqitch-pgtap:2.5.0

  alpine 3.18
  sqitch (App::Sqitch) v1.4.0
  pgtap 1.3.1
  pg_prove 3.36
```

### Core commands

- `sqitch`: Runs sqitch
- `pg_prove`: Runs pg_prove directly
- `pgtap install`: Installs pgTAP in the current database
- `pgtap uninstall`: Uninstalls pgTAP from the current database
- `pgtap test`: Installs pgTAP, runs pg_prove, and then uninstalls pgTAP
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
[disaykin/pgtap-docker-image]: https://github.com/disaykin/pgtap-docker-image
[docker-sqitch]: https://github.com/sqitchers/docker-sqitch
[lren-chuv/docker-pgtap]: https://github.com/LREN-CHUV/docker-pgtap
[pgtap]: https://pgtap.org
[sqitch]: https://sqitch.org
[theory/tap-parser-sourcehandler-pgtap]: https://github.com/theory/tap-parser-sourcehandler-pgtap
[pgxn]: https://pgxn.org/dist/pgtap/
