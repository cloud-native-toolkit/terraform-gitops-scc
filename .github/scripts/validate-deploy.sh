#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/1-infrastructure/active/cluster.yaml" ]]; then
  echo "Argocd config missing: argocd/1-infrastructure/active/cluster.yaml"
  exit 1
fi

cat argocd/1-infrastructure/active/cluster.yaml

if [[ $(ls "payload/1-infrastructure/cluster" | wc -l) -eq 0 ]]; then
  echo "Payload missing: payload/1-infrastructure/cluster"
  exit 1
fi

ls "payload/1-infrastructure/cluster"

cd ..
rm -rf .testrepo
