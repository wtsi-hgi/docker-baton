#!/usr/bin/env bats
TEST_LOCATION="../0.16.1/irods-3.3.1"
SUT_NAME="baton 0.16.1 with iRODS 3.3.1"

load common
load irods-3-common

setup() {
    :
}

@test "${SUT_NAME} - baton installed" {
    docker run -e DEBUG=1 ${baton_image} baton
    [ "$?" -eq 0 ]
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
