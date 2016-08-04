#!/usr/bin/env bash
set -euv -o pipefail

if [ -z ${IRODS_VERSION+x} ];
then
    echo "IRODS_VERSION must be set";
fi
if [ -z ${PG_PLUGIN_VERSION+x} ];
then
    echo "PG_PLUGIN_VERSION must be set";
fi

# Settings
BATON_REPOSITORY=$1
BATON_BRANCH=$2

# Environment variables for use in build
IRODS_SETTINGS_DIRECTORY=/root/.irods
RENCI_URL=ftp://ftp.renci.org
PLATFORM=ubuntu14
TEMP_WORKING_DIRECTORY=/tmp/installing

# Make temp working directory
mkdir -p ${TEMP_WORKING_DIRECTORY}

# Install iRODS
cd ${TEMP_WORKING_DIRECTORY}
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-icat-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-database-plugin-postgres-${PG_PLUGIN_VERSION}-${PLATFORM}-x86_64.deb
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-runtime-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
wget ${RENCI_URL}/pub/irods/releases/${IRODS_VERSION}/${PLATFORM}/irods-dev-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
# This is going to fail but then the line afterwards will magically fix things so suppressing the failure
dpkg -i irods-icat-${IRODS_VERSION}-${PLATFORM}-x86_64.deb irods-database-plugin-postgres-${PG_PLUGIN_VERSION}-${PLATFORM}-x86_64.deb 2> /dev/null || true
apt-get -f -y install
dpkg -i irods-runtime-${IRODS_VERSION}-${PLATFORM}-x86_64.deb irods-dev-${IRODS_VERSION}-${PLATFORM}-x86_64.deb
mkdir -p ${IRODS_SETTINGS_DIRECTORY}

# Install jansson
cd ${TEMP_WORKING_DIRECTORY}
git clone --depth 1 --branch v2.7 https://github.com/akheron/jansson.git jansson
cd jansson
autoreconf -fvi
./configure
make
make install

# Install baton
cpanm JSON List::AllUtils
cd ${TEMP_WORKING_DIRECTORY}
git clone --depth 1 --branch ${BATON_BRANCH} ${BATON_REPOSITORY} baton
cd baton
# Fixes an issue with missing ./ltmain.sh when running autoreconf
ln -sf /usr/share/libtool/config/ltmain.sh .
autoreconf -fvi
./configure --with-irods
make
make install

# Clean up temp working directory
rm -rf ${TEMP_WORKING_DIRECTORY}
