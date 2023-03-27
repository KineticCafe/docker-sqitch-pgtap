pg_prove_version := `jq -r .pg_prove.version < package-versions.json`
pgtap_version := `jq -r .pgtap.version < package-versions.json`
pgtap_hashref := `jq -r .pgtap.hashref < package-versions.json`
sqitch_version := `jq -r .sqitch.version < package-versions.json`

build:
  #!/usr/bin/env bash

  set -euo pipefail

  docker build \
    --build-arg PG_PROVE_VERSION="{{ pg_prove_version }}" \
    --build-arg PGTAP_VERSION="{{ pgtap_version }}" \
    --build-arg SQITCH_VERSION="{{ sqitch_version }}" \
    --tag kineticcafe/sqitch-pgtap:latest .

get-pgtap:
  #!/usr/bin/env bash

  set -euo pipefail

  rm -rf "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}" \
    "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}.zip" \
    "{{ justfile_directory() }}/pgtap.tar"

  if [[ -n "{{ pgtap_hashref }}" ]]; then
    git clone https://github.com/theory/pgtap.git \
      "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}"
    git -C "{{ justfile_directory() }}/build/pgtap/pgtap-{{ pgtap_version }}" switch --detach "{{ pgtap_hashref }}"
  else
    curl -sq -LO \
      "https://api.pgxn.org/dist/pgtap/{{ pgtap_version }}/pgtap-{{ pgtap_version }}.zip"
    unzip -d "{{ justfile_directory() }}/build/pgtap" "pgtap-{{ pgtap_version }}.zip"
  fi

  docker build --build-arg PGTAP_VERSION="{{ pgtap_version }}" \
    --tag build-pgtap:latest "{{ justfile_directory() }}/build/pgtap"
  docker container create --name builder build-pgtap:latest
  docker container cp --quiet builder:/opt/pgtap.tar "{{ justfile_directory() }}"
  docker container rm builder
  docker image rm build-pgtap:latest
  tar xf pgtap.tar

  rm -rf {{ justfile_directory() }}/build/pgtap/pgtap-"{{ pgtap_version }}" \
    {{ justfile_directory() }}/build/pgtap/pgtap-"{{ pgtap_version }}".zip \
    {{ justfile_directory() }}/pgtap.tar
