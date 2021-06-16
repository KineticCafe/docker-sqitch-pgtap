# Sqitch & pgTAP in Docker

This is a simple Docker container that contains [sqitch], [pgTAP], and
[`pg_prove`]. It has been created so that it's easier to work with `sqitch` and
`pg_prove`/`pgTAP` without going through the effort of installing them on
various systems.

The image is Alpine based and does not include the PostgreSQL server; instead,
it is expected that all values will be provided through environment variables or
on the command-line.

This version of the container includes:

- pgTAP 1.1.0
- pg_prove 3.35
- Sqitch 1.1.0

## Support

Tests have been made on Ubuntu 18 and macOS 11 (Apple Silicon). More tests are
underway.

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
