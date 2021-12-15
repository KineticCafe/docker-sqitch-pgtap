# docker-sqitch-pgtap Changelog

## 1.1.0 / 2021-12-14

- Update base alpine version to 3.15

- Update tool versions:

  - pgTAP 1.2.0
  - pg_prove 3.35 (`TAP::Parser::SourceHandler::pgTAP`)
  - sqitch 1.2.1 (`App::Sqitch`)

- Added postgres 14. Please note that postgres 9.6 has reached end-of-life, and
  will be removed in a future version.

## 1.0.1 / 2021-06-16

- Create the `sqitch` user as a non-system user for safety purposes.

## 1.0 / 2021-05-16

- Initial released version.
