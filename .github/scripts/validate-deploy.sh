#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

cat gitops-output.json

NAME=$(jq -r '.name // "my-module"' gitops-output.json)
BRANCH=$(jq -r '.branch // "main"' gitops-output.json)
SERVER_NAME=$(jq -r '.server_name // "default"' gitops-output.json)
LAYER=$(jq -r '.layer_dir // "2-services"' gitops-output.json)
TYPE=$(jq -r '.type // "base"' gitops-output.json)
NAMESPACE=$(jq -r '.namespace // "gitops-sccs"' gitops-output.json)
SERVICE_ACCOUNT=$(jq -r '.service_account // empty' gitops-output.json)
GROUP=$(jq -r '.group // false' gitops-output.json)

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${NAME}.yaml" ]]; then
  echo "Argocd config missing: argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${NAME}.yaml"
  exit 1
fi

cat "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${NAME}.yaml"

if [[ ! -d "payload/${LAYER}/namespace/${NAMESPACE}/${NAME}" ]]; then
  echo "Payload dir missing: payload/${LAYER}/namespace/${NAMESPACE}/${NAME}"
  exit 1
fi

ls "payload/${LAYER}/namespace/${NAMESPACE}/${NAME}"

if [[ "${GROUP}" == "true" ]]; then
  FILE_NAME="scc-${NAMESPACE}-anyuid.yaml"
else
  FILE_NAME="scc-${NAMESPACE}-${SERVICE_ACCOUNT}-anyuid.yaml"
fi

if [[ ! -f "payload/${LAYER}/namespace/${NAMESPACE}/${NAME}/${FILE_NAME}" ]]; then
  echo "Payload config missing: payload/${LAYER}/namespace/${NAMESPACE}/${NAME}/${FILE_NAME}"
  exit 1
fi

echo "Contents of payload: payload/${LAYER}/namespace/${NAMESPACE}/${NAME}/${FILE_NAME}"
cat "payload/${LAYER}/namespace/${NAMESPACE}/${NAME}/${FILE_NAME}"

cd ..
rm -rf .testrepo
