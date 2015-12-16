#!/usr/bin/env bash
set -e
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIRECTORY/../"

echo "Building baton Docker"
. scripts/build.sh

echo "Starting baton Docker in debug mode (not yet connected to iRODS server)"
docker run -e DEBUG=1 -it "wtsi-hgi/baton:custom-$batonBranch"
