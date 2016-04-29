#!/usr/bin/env bash
set -eu -o pipefail

IRODS_HOST=$1
IRODS_PORT=$2
IRODS_USERNAME=$3
IRODS_ZONE=$4
SETTINGS_FILE=$5

cat > ${SETTINGS_FILE} <<EOL
{
    "irods_host": "${IRODS_HOST}",
    "irods_port": ${IRODS_PORT},
    "irods_user_name": "${IRODS_USERNAME}",
    "irods_zone_name": "${IRODS_ZONE}"
}
EOL