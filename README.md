# Sqitch & pgTAP in Docker

This is a simple Docker container that contains [sqitch], [pgTAP], and
[`pg_prove`]. This is the _first version_ of the container. It has been created
so that it's easier to work with `sqitch` and `pg_prove`/`pgTAP` without going
through the effort of installing them on various systems.

The image is Alpine based and does not include the PostgreSQL server; instead,
it is expected that all values will be provided through environment variables or
on the command-line.

This image is based loosely on the Docker images in:

- [theory/tap-parser-sourcehandler-pgtap]
- [LREN-CHUV/docker-pgtap]
- [disaykin/pgtap-docker-image] ([gitlab.com/ringingmountain/docker/pgtap])

[sqitch]: https://sqitch.org
[pgtap]: https://pgtap.org
[`pg_prove`]: https://pgtap.org/pg_prove.html
[theory/tap-parser-sourcehandler-pgtap]: https://github.com/theory/tap-parser-sourcehandler-pgtap
[lren-chuv/docker-pgtap]: https://github.com/LREN-CHUV/docker-pgtap
[disaykin/pgtap-docker-image]: https://github.com/disaykin/pgtap-docker-image
[gitlab.com/ringingmountain/docker/pgtap]: https://gitlab.com/ringingmountain/docker/pgtap
