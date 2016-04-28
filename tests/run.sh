#!/usr/bin/env bash
bats test-base-for-baton-with-irods-3.3.1.bats

TEST_LOCATION="../0.16.1/irods-3.3.1" SUT_NAME="baton 0.16.1 with iRODS 3.3.1" bats test-baton-with-irods-3.3.1.bats
TEST_LOCATION="../0.16.2/irods-3.3.1" SUT_NAME="baton 0.16.2 with iRODS 3.3.1" bats test-baton-with-irods-3.3.1.bats
TEST_LOCATION="../devel/irods-3.3.1" SUT_NAME="baton devel with iRODS 3.3.1" bats test-baton-with-irods-3.3.1.bats