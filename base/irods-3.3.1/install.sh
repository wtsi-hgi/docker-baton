#!/usr/bin/env bash
set -eu -o pipefail

# Settings
BATON_REPOSITORY=$1
BATON_BRANCH=$2
PATCHSET=/tmp/patchset

# Environment variables
TEMP_WORKING_DIRECTORY=/tmp/installing
IRODS_VERSION=3.3.1
export IRODS_HOME=/software/irods-legacy/iRODS
export LD_LIBRARY_PATH=/usr/local/lib

apt-get update
apt-get install -y --no-install-recommends \
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

# Install iRODS
mkdir -p $IRODS_HOME
cd $IRODS_HOME
git clone --depth 1 --branch $IRODS_VERSION https://github.com/irods/irods-legacy.git
patch scripts/perl/configure.pl $PATCHSET/iRODS-configure.diff
patch lib/Makefile $PATCHSET/iRODS-lib-Makefile.diff
perl scripts/perl/configure.pl
make libs
# icommands are not required for baton but may be useful in debugging iRODS server connection issues
make icommands

# Install jansson
cd $TEMP_WORKING_DIRECTORY
git clone --depth 1 --branch v2.6 https://github.com/akheron/jansson.git jansson
cd jansson
autoreconf -fvi
./configure
make
make install

# baton also requires a bunch of Perl modules
cpanm JSON List::AllUtils

# Build baton
cd $TEMP_WORKING_DIRECTORY
git clone --depth 1 --branch $BATON_BRANCH $BATON_REPOSITORY baton
cd baton
autoreconf -fvi
./configure --with-irods=$IRODS_HOME
make
make install

# Make settings folder for baton/iRODs
mkdir -p $(dirname $IRODS_SETTINGS)

# Clean up temp working directory
rm -rf $TEMP_WORKING_DIRECTORY