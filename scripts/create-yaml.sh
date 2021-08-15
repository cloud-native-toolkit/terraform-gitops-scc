#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CONFIG_DIR=$(cd "${SCRIPT_DIR}/../config"; pwd -P)

REPO_PATH="$1"
NAMESPACE="$2"
SERVICE_ACCOUNT_NAME="$3"
SCCS="$4"

if [[ -z "${BIN_DIR}" ]]; then
  BIN_DIR="./bin"
fi

JQ=$(command -v jq || command -v ${BIN_DIR}/jq)

YQ=$(command -v yq || command -v ${BIN_DIR}/yq4)

${YQ} --version

echo "Repo path: ${REPO_PATH}"

mkdir -p "${REPO_PATH}"

export USER="system:serviceaccount:${NAMESPACE}:${SERVICE_ACCOUNT_NAME}"

echo "${SCCS}" | ${JQ} -r '.[]' | while read scc; do
  if [[ -f "${CONFIG_DIR}/scc-${scc}.yaml" ]]; then
    echo "Processing scc: ${scc}"

    NAME="${NAMESPACE}-${SERVICE_ACCOUNT_NAME}-${scc}"

    if [[ "$(yq --version)" =~ yq.version.3 ]]; then
      cat "${CONFIG_DIR}/scc-${scc}.yaml" | \
        ${YQ} w - 'metadata.name' "${NAME}" | \
        ${YQ} w - 'users[+]' "${USER}" > "${REPO_PATH}/scc-${NAME}.yaml"
    else
      cat "${CONFIG_DIR}/scc-${scc}.yaml" | \
        ${YQ} e '.metadata.name = env(NAME)' - | \
        ${YQ} e '.users += [env(USER)]' - > "${REPO_PATH}/scc-${NAME}.yaml"
    fi
  else
    echo "Unknown scc: ${scc}"
  fi
done

ls "${REPO_PATH}"
