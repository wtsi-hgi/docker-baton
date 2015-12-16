#!/usr/bin/env bash
set -e
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIRECTORY/../"

. scripts/_load-args.sh

docker build --build-arg BRANCH="$batonBranch" --build-arg REPOSITORY="$batonRepository" -t "wtsi-hgi/baton:custom-$batonBranch" -f "custom/$irodsVariant/Dockerfile" .
