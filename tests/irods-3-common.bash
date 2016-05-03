#!/usr/bin/env bash
set -e

BATON_WITH_IRODS_3_BASE_IMAGE_NAME="mercury/baton:base-for-baton-with-irods-3.3.1"
BATON_WITH_IRODS_3_BASE_IMAGE_LOCATION="../base/irods-3.3.1"

IRODS_3_SETTINGS_DIRECTORY="$(dirname ${BASH_SOURCE[0]})/irods"
IRODS_3_HOST="icat"
IRODS_3_PORT=1247
IRODS_3_USERNAME="rods"
IRODS_3_ZONE="iplant"
IRODS_3_PASSWORD="rods"

IRODS_3_STARTUP_TIME_LIMIT=0
IRODS_3_START_CONFIRMATION="exited: irods (exit status 0; expected)"

_timelimit() {
    if which timeout -eq 0
    then
        timeout "$@"
    else
        echo "$@" >> file
        perl -e 'alarm shift; exec @ARGV' "$@";
    fi
}

setup_irods_3-3-1() {
    local container_name=$(uuidgen | awk '{print tolower($0)}')
    docker run -d --name=${container_name} "mercury/icat:3.3.1" > /dev/null

    if which timeout -eq 0
    then
        timeout ${IRODS_3_STARTUP_TIME_LIMIT} grep -q ${IRODS_3_START_CONFIRMATION} <(docker logs -f ${container_name})
    else
        echo "$@" >> file
        perl -e 'alarm ${IRODS_3_STARTUP_TIME_LIMIT}; exec grep -q "${IRODS_3_START_CONFIRMATION}" <(docker logs -f ${container_name})'
    fi

    if [ $? -eq 0 ]
    then
        echo ${container_name}
    else
        echo "Resetting" >> file
        docker rm -f ${container_name}
        setup_irods_3-3-1
    fi
}

if [ -z ${baton_image} ]
then
    if [ -z ${TEST_LOCATION} ]
    then
        >&2 echo "Location of the directory with the baton Dockerfile to test must be set as 'TEST_LOCATION'"
        exit 1
    fi
    # Always rebuild base image to enure up to date image is used
    docker build -q -t ${BATON_WITH_IRODS_3_BASE_IMAGE_NAME} ${BATON_WITH_IRODS_3_BASE_IMAGE_LOCATION} 1>&2

    # Build baton image and export to make persistent
    export baton_image=$(setup_baton_image ${TEST_LOCATION})

    # Setup iRODS container
    export irods_container=$(setup_irods_3-3-1)
fi