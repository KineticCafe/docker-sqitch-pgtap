pg_prove_version := `jq -r .pg_prove.version < package-versions.json`
pgtap_version := `jq -r .pgtap.version < package-versions.json`
pgtap_hashref := `jq -r '.pgtap.hashref // empty' < package-versions.json`
sqitch_version := `jq -r .sqitch.version < package-versions.json`
alpine_version := `jq -r .alpine.version < package-versions.json`
image_version := `jq -r .VERSION < package-versions.json`

# Show the version as it would be from the built image
version:
  #!/usr/bin/env bash

  set -euo pipefail

  declare pgtap_version pgtap_hashref
  pgtap_version="{{ pgtap_version }}"
  pgtap_hashref="{{ pgtap_hashref }}"

  if [[ -n "${pgtap_hashref}" ]] && [[ "${pgtap_hashref}" != null ]]; then
    pgtap_version="${pgtap_version} (${pgtap_hashref})"
  fi

  cat <<EOS
  [gchr.io/]kineticcafe/sqitch-pgtap:{{ image_version }}

    alpine {{ alpine_version }}
    sqitch (App::Sqitch) v{{ sqitch_version }}
    pgtap ${pgtap_version}
    pg_prove {{ pg_prove_version }}
  EOS

# Set new alpine version
alpine-set-version NEW_VERSION:
  @just _update_package_versions alpine.version {{ NEW_VERSION }}
  @jq '.defaults.alpine = "{{ NEW_VERSION }}"' \
    {{ justfile_directory() }}/build/pgtap/versions.json | \
    sponge {{ justfile_directory() }}/build/pgtap/versions.json

# Set the new sqitch version
sqitch-set-version NEW_VERSION:
  @just _update_package_versions sqitch.version {{ NEW_VERSION }}

# Set the new pgtap version
pgtap-set-version NEW_VERSION NEW_HASHREF="":
  #!/usr/bin/env bash

  just _update_package_versions pgtap.version {{ NEW_VERSION }}

  declare new_hashref
  new_hashref="{{ NEW_HASHREF }}"

  if [[ -n "${new_hashref}" ]]; then
    just _update_package_versions pgtap.hashref "${new_hashref}"
  fi

# Set the new pgtap git hashref
pgtap-set-hashref NEW_VERSION:
  @just _update_package_versions pgtap.hashref {{ NEW_VERSION }}

# Clear the pgtap git hashref
pgtap-remove-hashref:
  @jq -c 'if (.pgtap | has("hashref")) then del(.pgtap.hashref) else . end' \
    package-versions.json | sponge package-versions.json

# Set the new pg_prove version
pg_prove-set-version NEW_VERSION:
  @just _update_package_versions pg_prove.version {{ NEW_VERSION }}

# Set the image version
set-version NEW_VERSION:
  @just _update_package_versions VERSION {{ NEW_VERSION }}

# Build the image
build:
  #!/usr/bin/env bash

  set -euo pipefail

  docker build \
    --build-arg ALPINE_VERSION="{{ alpine_version }}" \
    --build-arg PG_PROVE_VERSION="{{ pg_prove_version }}" \
    --build-arg PGTAP_VERSION="{{ pgtap_version }}" \
    --build-arg SQITCH_VERSION="{{ sqitch_version }}" \
    --build-arg __DOCKERFILE_VERSION__="{{ image_version }}" \
    --tag kineticcafe/sqitch-pgtap:latest .

# Update the pgTAP sources
update-pgtap: _download_pgtap _generate_pgtap_dockerfile
  #!/usr/bin/env bash

  set -euo pipefail

  docker build \
    --build-arg PGTAP_VERSION="{{ pgtap_version }}" \
    --tag build-pgtap:latest \
    "{{ justfile_directory() }}/build/pgtap"
  docker container create --name builder build-pgtap:latest
  docker container cp --quiet builder:/opt/pgtap.tar "{{ justfile_directory() }}"
  docker container rm builder
  docker image rm build-pgtap:latest
  tar xf pgtap.tar

  rm -rf {{ justfile_directory() }}/build/pgtap/pgtap-"{{ pgtap_version }}" \
    {{ justfile_directory() }}/build/pgtap/pgtap-"{{ pgtap_version }}".zip \
    {{ justfile_directory() }}/pgtap.tar

  git add opt/pgtap

_download_pgtap:
  #!/usr/bin/env bash

  set -euo pipefail

  rm -rf "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}" \
    "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}.zip" \
    "{{ justfile_directory() }}/pgtap.tar"

  if [[ -n "{{ pgtap_hashref }}" ]]; then
    git clone https://github.com/theory/pgtap.git \
      "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}"
    git -C "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}" \
      switch --detach "{{ pgtap_hashref }}"
  else
    curl -sq -LO \
      "https://api.pgxn.org/dist/pgtap/{{ pgtap_version }}/pgtap-{{ pgtap_version }}.zip"
    unzip -qq -d "{{ justfile_directory() }}/build/pgtap" "pgtap-{{ pgtap_version }}.zip"
  fi

_generate_pgtap_dockerfile:
  #!/usr/bin/env ruby

  require 'json'

  versions = JSON.load_file("{{ justfile_directory() }}/build/pgtap/versions.json")

  blocks = versions["postgres"].map { |pg_version|
    name = pg_version.fetch("name")
    version = pg_version.fetch("version") { name }
    alpine = pg_version.fetch("alpine") { versions.dig("defaults", "alpine") }

    <<~BUILD_BLOCK
      FROM postgres:#{version}-alpine#{alpine} AS build-pgtap-psql-#{name}

      ARG PGTAP_VERSION

      COPY pgtap-$PGTAP_VERSION /opt/pgtap-$PGTAP_VERSION

      RUN <<SETUP
      set -eux

      apk update

      apk add \\
        bash \\
        build-base \\
        make \\
        openssl \\
        perl \\
        perl-dev \\
        postgresql-dev \\
        wget

      wanted_clang=$(
        pg_config --configure |
          tr ' ' '\\n' |
          grep CLANG |
          sed "s/'CLANG=\\(.*\\)'/\\1/"
      )

      if ! command -v "${wanted_clang}" >/dev/null 2>/dev/null; then
        version="${wanted_clang/clang-}"
        apk add clang"${version}" llvm"${version}"
      fi

      mkdir -p /opt/pgtap/#{name}
      SETUP

      RUN <<BUILD
      set -eux

      cd /opt/pgtap-$PGTAP_VERSION
      make
      make install
      mv sql/pgtap.sql sql/uninstall_pgtap.sql /opt/pgtap/#{name}
      BUILD
    BUILD_BLOCK

  }

  copy = versions["postgres"].map { |pg_version|
    name = pg_version.fetch("name")
    "COPY --from=build-pgtap-psql-#{name} /opt/pgtap/#{name} /opt/pgtap/#{name}"
  }

  dockerfile = <<~DOCKERFILE
    # syntax=docker/dockerfile:1

    #{blocks.join("\n\n")}

    FROM alpine:{{ alpine_version }} AS package-pgtap

    RUN mkdir -p /opt/pgtap

    #{copy.join("\n")}

    RUN tar cf /opt/pgtap.tar /opt/pgtap
  DOCKERFILE

  File.write("build/pgtap/Dockerfile", dockerfile)

_update_package_versions key value:
  @jq -c '.{{ key }} = "{{ value }}"' {{ justfile_directory() }}/package-versions.json | \
    sponge {{ justfile_directory() }}/package-versions.json
