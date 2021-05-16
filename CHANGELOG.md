# docker-sqitch-pgtap Changelog

## 0.0.3 / 2021-05-15

- Add `tzdata` to the Docker image to help `sqitch` run.
- Improve the `run` script to talk to the Docker host if `PGHOST` is not
  provided.

## 0.0.2 / 2021-05-14

- Disable the Dockerhub README update action temporarily.
- Disable the GitHub Container Registry setup temporarily.

## 0.0.1 / 2021-05-14

- Attempt to build a multi-arch Docker image via GitHub Actions.
- Created.
