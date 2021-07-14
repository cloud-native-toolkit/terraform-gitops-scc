#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CONFIG_DIR=$(cd "${SCRIPT_DIR}/../config"; pwd -P)

REPO_PATH="$1"
NAMESPACE="$2"
SERVICE_ACCOUNT_NAME="$3"
SCCS="$4"

JQ=$(command -v jq || command -v ./bin/jq)

if [[ -z "${JQ}" ]]; then
  echo "jq missing. Installing"
  mkdir -p ./bin && curl -Lo ./bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  chmod +x ./bin/jq
  JQ="${PWD}/bin/jq"
fi

YQ=$(command -v yq || command -v ./bin/yq)

if [[ -z "${YQ}" ]]; then
  echo "jq missing. Installing"
  mkdir -p ./bin && curl -Lo ./bin/yq https://github.com/mikefarah/yq/releases/download/v4.9.8/yq_linux_amd64
  chmod +x ./bin/yq
  YQ="${PWD}/bin/yq"
fi

mkdir -p "${REPO_PATH}"

export USER="system:serviceaccount:${NAMESPACE}:${SERVICE_ACCOUNT_NAME}"

echo "${SCCS}" | ${JQ} -r '.[]' | while read scc; do
  if [[ -f "${CONFIG_DIR}/scc-${scc}.yaml" ]]; then
    export NAME="${NAMESPACE}-${SERVICE_ACCOUNT_NAME}-${scc}"

    cat "${CONFIG_DIR}/scc-${NAME}.yaml" | \
      ${YQ} e '.metadata.name = env(NAME)' - | \
      ${YQ} e '.users += [env(USER)]' - > "${REPO_PATH}/scc-${NAME}.yaml"
  else
    echo "Unknown scc: ${scc}"
  fi
done
