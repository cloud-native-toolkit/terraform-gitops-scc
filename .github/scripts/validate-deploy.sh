#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)


NAMESPACE="gitops-sccs"
SERVICE_ACCOUNT="test-sa"
SERVER_NAME="default"
NAME="${SERVICE_ACCOUNT}-scc"

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/1-infrastructure/cluster/${SERVER_NAME}/base/${NAMESPACE}-${NAME}.yaml" ]]; then
  echo "Argocd config missing: argocd/1-infrastructure/cluster/${SERVER_NAME}/base/${NAMESPACE}-${NAME}.yaml"
  exit 1
fi

cat argocd/1-infrastructure/cluster/${SERVER_NAME}/base/${NAMESPACE}-${NAME}.yaml

if [[ ! -d "payload/1-infrastructure/namespace/${NAMESPACE}/${NAME}" ]]; then
  echo "Payload dir missing: payload/1-infrastructure/namespace/${NAMESPACE}/${NAME}"
  exit 1
fi

ls "payload/1-infrastructure/namespace/${NAMESPACE}/${NAME}"

cd ..
rm -rf .testrepo
