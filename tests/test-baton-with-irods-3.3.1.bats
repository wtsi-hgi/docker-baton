#!/usr/bin/env bats
if [[ -z ${TEST_LOCATION} ]]
then
    >&2 echo "The test location must be set via the 'TEST_LOCATION' environmental variable"
    exit 1
elif [[ -z ${SUT_NAME} ]]
then
    >&2 echo "The SUT name must be set via the 'SUT_NAME' environmental variable"
    exit 1
fi

load common
load irods-3-common

setup() {
    :
}

@test "${SUT_NAME} - baton installed" {
    out=$(docker run -e DEBUG=1 ${baton_image} baton)
    [ ${out} == "{\"avus\":[]}" ]
}

@test "${SUT_NAME} - icommands installed" {
    docker run -e DEBUG=1 ${baton_image} ils -h
    [ "$?" -eq 0 ]
}

@test "${SUT_NAME} - jq installed" {
    docker run -e DEBUG=1 ${baton_image} baton
    [ "$?" -eq 0 ]
}

@test "${SUT_NAME} - baton can connect to iRODS with .irodsEnv" {
    out=$(docker run \
        -v ${IRODS_3_SETTINGS_DIRECTORY}:/root/.irods \
        -e IRODS_PASSWORD=${IRODS_3_PASSWORD} \
        --link ${irods_container}:icat \
        ${baton_image} \
        bash -c "jq -n '{collection: \"/\"}' | baton-list --unsafe")
    [ "$?" -eq 0 ]
}

@test "${SUT_NAME} - baton can connect to iRODS all settings as arguments" {
    out=$(docker run \
        -e IRODS_HOST=${IRODS_3_HOST} \
        -e IRODS_PORT=${IRODS_3_PORT} \
        -e IRODS_USERNAME=${IRODS_3_USERNAME} \
        -e IRODS_ZONE=${IRODS_3_ZONE} \
        -e IRODS_PASSWORD=${IRODS_3_PASSWORD} \
        --link ${irods_container}:icat \
        ${baton_image} \
        bash -c "jq -n '{collection: \"/\"}' | baton-list --unsafe")
    [ "$?" -eq 0 ]
}

@test "${SUT_NAME} - icommands can connect to iRODS" {
    out=$(docker run \
        -v ${IRODS_3_SETTINGS_DIRECTORY}:/root/.irods \
        -e IRODS_PASSWORD=${IRODS_3_PASSWORD} \
        --link ${irods_container}:icat \
        ${baton_image} \
        ils)
    [ "$?" -eq 0 ]
}

teardown() {
    remove_image_if_no_more_tests ${baton_image}
    remove_container_if_no_more_tests ${irods_container}
}
