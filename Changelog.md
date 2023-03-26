# docker-sqitch-pgtap Changelog

## 2.1.0 / 2023-03-26

- Changed how the primary docker image is built by using a secondary docker
  image. This has been done primarily to speed up the build process under GitHub
  Actions as we build for `linux/amd64`, `linux/arm64`, and `linux/arm/v7`, and
  the construction of the pgTAP scripts did not need to be repeated three times
  (there is no difference based on the architecture, just on the PostgreSQL
  version).

  This change means that we can support more versions of PostgreSQL without
  caring about released base image as there are no compiled files. As such, we
  have re-added support for PostgreSQL 9.6 on a best-effort basis.

- Added a [Maintenance](Maintenance.md) document.

- Docker build arguments are no longer defaulted in the main `Dockerfile`, but
  are stored in `package-versions.json`. The `Justfile` reads these for use with
  the `build` target (`just build`) and the GitHub Actions workflow via
  `fromJson`.

- Update support for the released version of PostgreSQL 15.

- Update base Alpine version to 3.17.

- Add GHCR publishing.

## 2.0.1 / 2022-10-04

- Update sqitch version to 1.3.1.

- Update PostgreSQL 15 to RC 1 from beta 3.

## 2.0.0 / 2022-08-23

- Update base alpine version to 3.16. Made the use of alpine 3.16 explicit in
  the specification of the PostgreSQL versions in the docker file.

- Update tool versions:

  - pgTAP 1.2.1+ (from git)
  - pg_prove 3.36 (`TAP::Parser::SourceHandler::pgTAP`)
  - sqitch 1.3.0 (`App::Sqitch`)

- Added PostgreSQL 15 beta 3.

- Removed PostgreSQL 9.6.

- Backported several changes to the `run` script made during the full adoption
  of this image and run script internally at Kinetic.

  - Add a way of getting the current Docker context so that when running under
    `colima`, the appropriate internal host name can be used to reach a database
    on the host server.

  - Fix a bug where `date +%Z` does not work on Linux the way it does on macOS.
    Always default to a timezone of `Etc/UTC`.

  - Map the user by ID into the docker image to prevent file read, write, or
    cleanup issues.

  - Remove deprecated commands.

  - Standardize `structure.sql` cleaning.

  - Improve `structure.sql` comparison and report when there are no
    differences in the database structure.

- Changed all `scripts/*` files from `/bin/sh` to `/bin/bash`.

## 1.1.0 / 2021-12-14

- Update base alpine version to 3.15

- Update tool versions:

  - pgTAP 1.2.0
  - pg_prove 3.35 (`TAP::Parser::SourceHandler::pgTAP`)
  - sqitch 1.2.1 (`App::Sqitch`)

- Added PostgreSQL 14. Please note that PostgreSQL 9.6 has reached end-of-life,
  and will be removed in a future version.

## 1.0.1 / 2021-06-16

- Create the `sqitch` user as a non-system user for safety purposes.

## 1.0 / 2021-05-16

- Initial released version.

[extractions/setup-just]: https://github.com/extractions/setup-just
[casey/just]: https://github.com/casey/just
