#!/usr/bin/env bash
set -eu -o pipefail

# Settings
BATON_REPOSITORY=$1
BATON_BRANCH=$2
PATCHSET=/tmp/patchset

# Environment variables
IRODS_SETTINGS_DIRECTORY=/root/.irods
TEMP_WORKING_DIRECTORY=/tmp/installing
IRODS_VERSION=3.3.1
export IRODS_HOME=/software/irods-legacy/iRODS
export LD_LIBRARY_PATH=/usr/local/lib

# Make temp working directory
mkdir -p ${TEMP_WORKING_DIRECTORY}

# Install iRODS
mkdir /software
cd /software
git clone --depth 1 --branch ${IRODS_VERSION} https://github.com/irods/irods-legacy.git
cd irods-legacy/iRODS
patch scripts/perl/configure.pl ${PATCHSET}/iRODS-configure.diff
patch lib/Makefile ${PATCHSET}/iRODS-lib-Makefile.diff
perl scripts/perl/configure.pl
make libs
# icommands are not required for baton but may be useful in debugging iRODS server connection issues
make icommands
mkdir -p ${IRODS_SETTINGS_DIRECTORY}

# Install jansson
cd ${TEMP_WORKING_DIRECTORY}
git clone --depth 1 --branch v2.7 https://github.com/akheron/jansson.git jansson
cd jansson
autoreconf -fvi
./configure
make
make install

# baton also requires a bunch of Perl modules
cpanm JSON List::AllUtils

# Build baton
cd ${TEMP_WORKING_DIRECTORY}
git clone --depth 1 --branch ${BATON_BRANCH} ${BATON_REPOSITORY} baton

cd baton
# The below fixes an issue with missing ./ltmain.sh when running autoreconf
ln -sf /usr/share/libtool/config/ltmain.sh .
autoreconf -fvi
./configure --with-irods=${IRODS_HOME}
make
make install

# Clean up temp working directory
rm -rf ${TEMP_WORKING_DIRECTORY}
