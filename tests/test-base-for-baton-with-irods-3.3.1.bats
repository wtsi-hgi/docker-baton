#!/usr/bin/env bats
TEST_LOCATION="../base/irods-3.3.1"
SUT_NAME="base for baton with iRODS 3.3.1"

load common

setup() {
    base_image=$(setup_baton_image $TEST_LOCATION)
}

@test "${SUT_NAME} - install script added" {
    out=$(docker run -e DEBUG=1 ${base_image} cat /tmp/install.sh)
    [ "$?" -eq 0 ]
}

teardown() {
    remove_image_if_no_more_tests ${base_image}
}