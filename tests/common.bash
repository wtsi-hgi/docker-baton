#!/usr/bin/env bash
set -e

exit_signalled=false

setup_baton_image() {
    if [ -z $1 ]
    then
        >&2 echo "Build context location must be passed in as the first (and only) argument"
        exit 1
    fi
    local image_name="baton-image-test:$(uuidgen | awk '{print tolower($0)}')"
    docker build -q -t ${image_name} $1 1>&2
    echo ${image_name}
}

remove_image_if_no_more_tests() {
    if [ -z $1 ]
    then
        >&2 echo "Image name must be passed in as the first (and only) argument"
        exit 1
    fi
    if [ ${BATS_TEST_NUMBER} -eq ${#BATS_TEST_NAMES[@]} ] || [ ${exit_signalled} == true ]
    then
        docker rmi -f $1
    fi
}

remove_container_if_no_more_tests() {
    if [ -z $1 ]
    then
        >&2 echo "Container name must be passed in as the first (and only) argument"
        exit 1
    fi
    if [ ${BATS_TEST_NUMBER} -eq ${#BATS_TEST_NAMES[@]} ] || [ ${exit_signalled} == true ]
    then
        docker rm -f $1
    fi
}

on_exit() {
     exit_signalled=true
}
trap on_exit EXIT
