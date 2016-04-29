#!/usr/bin/env bash
set -eu -o pipefail

IRODS_HOST=$1
IRODS_PORT=$2
IRODS_USERNAME=$3
IRODS_ZONE=$4
SETTINGS_FILE=$5

echo "irodsUserName ${IRODS_USERNAME}" >> ${IRODS_SETTINGS}
echo "irodsHost ${IRODS_HOST}" >> ${IRODS_SETTINGS}
echo "irodsPort ${IRODS_PORT}" >> ${IRODS_SETTINGS}
echo "irodsZone ${IRODS_ZONE}" >> ${IRODS_SETTINGS}
