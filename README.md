# Sqitch & pgTAP in Docker

This is a simple Docker container that contains [sqitch], [pgTAP], and
[`pg_prove`]. It has been created so that it's easier to work with `sqitch` and
`pg_prove`/`pgTAP` without going through the effort of installing them on
various systems.

The image is based on Alpine (3.15) and does not include a PostgreSQL server;
instead, it is expected that all values will be provided through environment
variables or on the command-line.

This version of the container includes:

- pgTAP 1.2.0
  - Support for PostgreSQL 9.6, 10, 11, 12, 13, and 14
- pg_prove 3.36
- Sqitch 1.2.1

The version of pgTAP is installed and uninstalled as needed; the unit test files
must _not_ `CREATE EXTENSION pgtap`.

## `run` script Commands

The `run` script is recommended for running everything as it manages environment
variable configuration for each run.

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
- `nano`: Runs nano
- `show-targets`: Shows configured sqitch targets
- `show-default-target`: Shows the configured default target
- `show-default-dbname`: Shows the configured default target database name
- `pgtap-tests`: Runs `pgtap test test/*.sql` for the default database

## Sources

This image is based loosely on the Docker images in:

- [theory/tap-parser-sourcehandler-pgtap]
- [LREN-CHUV/docker-pgtap]
- [docker-sqitch]
- [disaykin/pgtap-docker-image]

[`pg_prove`]: https://pgtap.org/pg_prove.html
[disaykin/pgtap-docker-image]: https://github.com/disaykin/pgtap-docker-image
[docker-sqitch]: https://github.com/sqitchers/docker-sqitch
[lren-chuv/docker-pgtap]: https://github.com/LREN-CHUV/docker-pgtap
[pgtap]: https://pgtap.org
[sqitch]: https://sqitch.org
[theory/tap-parser-sourcehandler-pgtap]: https://github.com/theory/tap-parser-sourcehandler-pgtap
