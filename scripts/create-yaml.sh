#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CONFIG_DIR=$(cd "${SCRIPT_DIR}/../config"; pwd -P)

REPO_PATH="$1"
NAMESPACE="$2"
SCCS="$3"
SERVICE_ACCOUNT_NAME="$4"

if [[ -z "${BIN_DIR}" ]]; then
  BIN_DIR="./bin"
fi

JQ=$(command -v jq || command -v ${BIN_DIR}/jq)

YQ=$(command -v yq || command -v ${BIN_DIR}/yq4)

${YQ} --version

echo "Repo path: ${REPO_PATH}"

mkdir -p "${REPO_PATH}"

export USER="system:serviceaccount:${NAMESPACE}:${SERVICE_ACCOUNT_NAME}"
export GROUP="system:serviceaccount:${NAMESPACE}"

echo "${SCCS}" | ${JQ} -r '.[]' | while read scc; do
  if [[ -f "${CONFIG_DIR}/scc-${scc}.yaml" ]]; then

    if [[ -n "${SERVICE_ACCOUNT_NAME}" ]]; then
      echo "Processing ${scc} scc for service account ${NAMESPACE}/${SERVICE_ACCOUNT_NAME}"
      NAME="${NAMESPACE}-${SERVICE_ACCOUNT_NAME}-${scc}"

      cat "${CONFIG_DIR}/scc-${scc}.yaml" | \
        ${YQ} e '.metadata.name = env(NAME)' - | \
        ${YQ} e '.users += [env(USER)]' - > "${REPO_PATH}/scc-${NAME}.yaml"
    else
      echo "Processing ${scc} scc for namespace group ${NAMESPACE}"
      NAME="${NAMESPACE}-${scc}"

      cat "${CONFIG_DIR}/scc-${scc}.yaml" | \
        ${YQ} e '.metadata.name = env(NAME)' - | \
        ${YQ} e '.groups += [env(GROUP)]' - > "${REPO_PATH}/scc-${NAME}.yaml"
    fi
  else
    echo "Unknown scc: ${scc}"
  fi
done

ls "${REPO_PATH}"
