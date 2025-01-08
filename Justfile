version_file := justfile_directory() / "package-versions.json"
pgtap_versions := justfile_directory() / "build/pgtap/versions.json"
pg_prove_version := `jq -r .pg_prove.version < package-versions.json`
pgtap_version := `jq -r .pgtap.version < package-versions.json`
pgtap_hashref := `jq -r '.pgtap.hashref // empty' < package-versions.json`
sqitch_version := `jq -r .sqitch.version < package-versions.json`
alpine_version := `jq -r .alpine.version < package-versions.json`
image_version := `jq -r .VERSION < package-versions.json`
image_date := `jq -r .DATE < package-versions.json`

[private]
@list:
    just --list --unsorted

# Show the version as it would be from the built image
version NEW_VERSION="":
    #! /usr/bin/env bash

    set -euo pipefail

    rv() {
      jq -r ".$1" < {{ version_file }}
    }

    show() {
      local alpine_version image_date image_version pg_prove_version \
        pgtap_version pgtap_hashref sqitch_version

      alpine_version="$(rv alpine.version)"
      image_date="$(rv DATE)"
      image_version="$(rv VERSION)"
      pg_prove_version="$(rv pg_prove.version)"
      pgtap_hashref="$(rv pgtap.hashref)"
      pgtap_version="$(rv pgtap.version)"
      sqitch_version="$(rv sqitch.version)"

      if [[ -n "${pgtap_hashref}" ]] && [[ "${pgtap_hashref}" != null ]]; then
        pgtap_version="${pgtap_version} (${pgtap_hashref})"
      fi

      cat <<EOS
    [gchr.io/]kineticcafe/sqitch-pgtap:${image_version}

      alpine ${alpine_version}
      sqitch (App::Sqitch) v${sqitch_version}
      pgtap ${pgtap_version}
      pg_prove ${pg_prove_version}

    Last updated ${image_date}

    EOS
    }

    show

    if [[ "{{ NEW_VERSION }}" != "" ]]; then
      just update_package_versions VERSION {{ NEW_VERSION }}
      echo ""

      show
    fi

# Creates a git tag for the stored image version (only on main branch)
[no-exit-message]
@tag:
    if [[ "$(git branch --show-current)" == main ]]; then \
      git tag v{{ image_version }}; \
    else \
      echo "Must be on main branch to create tag v{{ image_version }}."; \
    fi

# Set the new sqitch version
sqitch NEW_VERSION: (update_package_versions "sqitch.version" NEW_VERSION)

# Set the new pgtap version
pgtap NEW_VERSION NEW_HASHREF="": (update_package_versions "pgtap.version" NEW_VERSION "pgtap.hashref" NEW_HASHREF)
    @git diff --quiet || just update-pgtap

# Set the new pg_prove version
pg_prove NEW_VERSION: (update_package_versions "pg_prove.version" NEW_VERSION)

# Set new alpine version
@alpine NEW_VERSION: (update_package_versions "alpine.version" NEW_VERSION)
    jq '.defaults.alpine = "{{ NEW_VERSION }}"' "{{ pgtap_versions }}" | \
      sponge "{{ pgtap_versions }}"
    git diff --quiet || just update-pgtap

# Add a new PostgreSQL version
postgres VERSION *EXTRA:
    #!/usr/bin/env bash

    set -euo pipefail

    set -- {{ EXTRA }}

    while (($#)); do
      case "$1" in
        using) using="$2" ;;
        alpine) alpine="$2" ;;
        eol) eol="$2" ;;
        *)
          echo >&2 "Unknown custom version expecting 'using', 'alpine', or 'eol'."
          exit 1
          ;;
      esac

      shift 2 || break
    done

    version="{{ VERSION }}"

    case "${version}" in
      =*)
        jq --arg version "${version:1}" \
          '.postgres[] | select(.name == $version)' \
          "{{ pgtap_versions }}"
        exit 0
        ;;
    esac

    jq --arg version "${version}" \
       --arg using "${using:-}" \
       --arg alpine "${alpine:-}" \
       --arg eol "${eol:-}" \
       '
       {name: $version} as $pg |
       (if $using == "" then $pg else $pg + {version: $using} end) as $pg |
       (if $alpine == "" then $pg else $pg + {alpine: $alpine} end) as $pg |
       (if $eol == "" then $pg else $pg + {eol: $eol} end) as $pg |
       .postgres |=
        (map(.name) | index($version)) as $ix |
        if $ix then .[$ix] = $pg else [$pg] + . end
    ' "{{ pgtap_versions }}" | sponge "{{ pgtap_versions }}"

    git diff --quiet || just update-pgtap

# Build a test version of the image
build:
    #!/usr/bin/env bash

    set -euo pipefail

    docker build \
      --build-arg ALPINE_VERSION="{{ alpine_version }}" \
      --build-arg PG_PROVE_VERSION="{{ pg_prove_version }}" \
      --build-arg PGTAP_VERSION="{{ pgtap_version }}" \
      --build-arg SQITCH_VERSION="{{ sqitch_version }}" \
      --build-arg __DOCKERFILE_VERSION__="{{ image_version }}" \
      --build-arg __DOCKERFILE_DATE__="{{ image_date }}" \
      --tag kineticcafe/sqitch-pgtap:latest \
      .

# Update pgTAP sources
update-pgtap: download_pgtap generate_pgtap_dockerfile && update-do_pgtap
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

[private]
download_pgtap:
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

[private]
generate_pgtap_dockerfile:
    #!/usr/bin/env ruby

    require 'json'

    versions = JSON.load_file("{{ pgtap_versions }}")

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
          version=$(echo "${wanted_clang}" | sed 's/clang-//')
          apk add clang"${version}" llvm"${version}"
        fi

        mkdir -p /opt/pgtap/#{name}
        SETUP

        WORKDIR /opt/pgtap-$PGTAP_VERSION

        RUN <<BUILD
        set -eux

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

      # hadolint global ignore=DL3018,DL3019,DL4006

      #{blocks.join("\n\n")}

      FROM alpine:{{ alpine_version }} AS package-pgtap

      RUN mkdir -p /opt/pgtap

      #{copy.join("\n")}

      RUN tar cf /opt/pgtap.tar /opt/pgtap
    DOCKERFILE

    File.write("build/pgtap/Dockerfile", dockerfile)

[private]
update-do_pgtap:
    #!/usr/bin/env ruby

    require 'json'

    versions = JSON.load_file("{{ pgtap_versions }}")

    clauses = versions["postgres"].sort_by { _1["name"].to_f }.map { |pg_version|
      name = pg_version.fetch("name")
      eol = pg_version["eol"]

      if eol
        <<~CLAUSE
          #{name}*)
            eol #{name} #{eol}
            version=#{name}
            ;;
        CLAUSE
      else
        "#{name}*) version=#{name} ;;\n"
      end
    }.join

    case_esac = <<~CASE
      case "${version}" in
      #{clauses.chomp}
      *)
        echo >&2 "Unknown or unsupported PostgreSQL version '${version}'."
        exit 1
        ;;
      esac
    CASE

    script = File
      .read("scripts/do_pgtap")
      .sub(/case "\$\{version\}" in.+?esac/m, case_esac.chomp)

    File.write("scripts/do_pgtap", script)

[private]
update_package_versions *args:
    #! /usr/bin/env bash

    set -euo pipefail

    set -- {{ args }}

    update() {
      local key value old
      key="$1"
      value="${2:-}"
      old="$(jq -r ".$1" < {{ version_file }})"

      jq -c --arg value "${value}" "
        path (.${key}) as \$key |
        if \$value == \"\" then
          delpaths([\$key])
        else
          setpath(\$key; \$value)
        end
      " "{{ version_file }}" | sponge "{{ version_file }}"

      tput setaf 1 && echo "- ${key} :: ${old}"
      [[ "${value}" == "" ]] || {
        tput setaf bold && tput setaf 2 && echo "+ ${key} :: ${value}"
      }

      tput sgr0
    }

    while (( $# )); do
      update "$1" "${2:-}"

      shift 2 || break
    done

    if ! git diff --quiet; then
      update DATE "$(date +"%Y-%m-%d")"
    fi
