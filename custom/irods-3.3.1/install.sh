#!/usr/bin/env bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
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

# Environment variables for use in build
SOFTWARE=/software
IRODS=$SOFTWARE/irods-legacy/iRODS
JANSSON=$SOFTWARE/jansson
BATON=$SOFTWARE/baton
PATCHSET=/patchset
IRODS_SETTINGS=/root/.irods/.irodsEnv
SCRIPTS=/scripts

# Environment variables used by software
export IRODS_HOME=$IRODS
export IRODS_VERSION=3.3.1
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Docker Hub assumes that the Dockerfile is in the project root. Therefore cannot COPY common files in without
# duplicating them in all of the version directories (Docker does not follow symlinks). Instead will get the files from
# GitHub, the downside of which is that development of the copied scripts becomes coupled to GitHub (unless this script
# is changed so that files under development are imported using COPY).
cd /tmp
git clone --depth 1 https://github.com/wtsi-hgi/docker-baton.git
cp -r docker-baton/patchset $PATCHSET
mkdir $SCRIPTS
cp docker-baton/setup.sh $SCRIPTS/setup.sh

# Fetch dependencies
mkdir $SOFTWARE
cd $SOFTWARE
git clone --depth 1 --branch $IRODS_VERSION https://github.com/irods/irods-legacy.git
git clone --depth 1 --branch v2.6 https://github.com/akheron/jansson.git
git clone --depth 1 --branch $BRANCH $REPOSITORY

# baton also requires a bunch of Perl modules
cpanm JSON List::AllUtils

# Patch and Build iRODS
cd $IRODS
patch scripts/perl/configure.pl $PATCHSET/iRODS-configure.diff
patch lib/Makefile $PATCHSET/iRODS-lib-Makefile.diff
perl scripts/perl/configure.pl
make libs
# icommands are not required for baton but may be useful in debugging iRODS
# server connection issues
make icommands
PATH=$PATH:$IRODS/clients/icommands/bin

# Build jansson
cd $JANSSON
autoreconf -fvi
./configure
make
make install

# Build baton
cd $BATON
autoreconf -fvi
./configure --with-irods=$IRODS_HOME
make
make install

# Make settings folder for baton/iRODs
mkdir -p $(dirname $IRODS_SETTINGS)
