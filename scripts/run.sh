#!/usr/bin/env bash
set -e
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIRECTORY/../"

batonVariant=$1
irodsVariant="irods-3.3.1"

source scripts/_argument-validation.sh
validateBatonVariant $1
validateIrodsVariant $1 $irodsVariant

docker build -t wtsi-hgi/baton:"$batonVariant" -f "$batonVariant"/"$irodsVariant"/Dockerfile .
echo "Starting baton Docker in debug mode (not connected to iRODS server)"
docker run -e DEBUG=1 -t wtsi-hgi/baton:"$batonVariant"
