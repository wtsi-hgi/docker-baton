#!/usr/bin/env bash
set -eu -o pipefail

# Settings
BATON_REPOSITORY=$1
BATON_BRANCH=$2

# Environment variables for use in build
IRODS_SETTINGS=/root/.irods
RENCI_URL=ftp://ftp.renci.org
IRODS_VERSION=4.1.8
PLATFORM=ubuntu14
PG_PLUGIN_VERSION=1.8
TEMP_WORKING_DIRECTORY=/tmp/installing

apt-get update
apt-get install -y --no-install-recommends \
    wget \
    git \
    gcc \
    g++ \
    perl \
    cpanminus \
    make \
    autoconf \
    automake \
    libtool \
    pkg-config \
    patch \
    ca-certificates \
    libboost-dev \
    libssl-dev \
    jq \
    perl-doc

# Make temp working directory
mkdir -p $TEMP_WORKING_DIRECTORY
cd $TEMP_WORKING_DIRECTORY

# Install iRODS
cd $TEMP_WORKING_DIRECTORY
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-icat-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-database-plugin-postgres-${PG_PLUGIN_VERSION}-${PLATFORM}-x86_64.deb
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-runtime-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-dev-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
# This is going to fail but then the line afterwards will magically fix things so suppressing the failure
dpkg -i irods-icat-${IRODS_VERSION}-${PLATFORM}-x86_64.deb irods-database-plugin-postgres-${PG_PLUGIN_VERSION}-${PLATFORM}-x86_64.deb 2> /dev/null || true
apt-get -f -y install
dpkg -i irods-runtime-${IRODS_VERSION}-${PLATFORM}-x86_64.deb irods-dev-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
mkdir -p $IRODS_SETTINGS

# Install jansson
git clone --depth 1 --branch v2.7 https://github.com/akheron/jansson.git jansson
cd jansson
autoreconf -fvi
./configure
make
make install

# Install baton
git clone --depth 1 --branch $BATON_BRANCH $BATON_REPOSITORY baton
cpanm JSON List::AllUtils
cd baton
autoreconf -fvi
./configure
make
make install

# Clean up temp working directory
rm -rf $TEMP_WORKING_DIRECTORY