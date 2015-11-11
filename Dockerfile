FROM debian:jessie
MAINTAINER "hgi@sanger.ac.uk"

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
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
    libssl-dev

# Environment variables
ENV IRODS_HOME /dependencies/irods-legacy/iRODS
ENV IRODS_VERSION 3.3.1
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Our changes required to compile
COPY patchset /patchset

# Fetch dependencies
RUN mkdir /dependencies
WORKDIR dependencies

RUN git clone --depth 1 --branch $IRODS_VERSION https://github.com/irods/irods-legacy.git
RUN git clone --depth 1 --branch v2.6 https://github.com/akheron/jansson.git
RUN git clone --depth 1 --branch 0.16.1 https://github.com/wtsi-npg/baton.git

# baton also requires a bunch of Perl modules
RUN cpanm JSON List::AllUtils

# Patch and Build iRODS
WORKDIR /dependencies/irods-legacy/iRODS
RUN patch scripts/perl/configure.pl /patchset/iRODS-configure.diff
RUN patch lib/Makefile /patchset/iRODS-lib-Makefile.diff
RUN perl scripts/perl/configure.pl
RUN make libs

# Build jansson
WORKDIR /dependencies/jansson
RUN autoreconf -fvi
RUN ./configure
RUN make
RUN make install

# Build baton
WORKDIR /dependencies/baton
RUN autoreconf -fvi
RUN ./configure --with-irods=$IRODS_HOME
RUN make
RUN make install

COPY baton-python-wrapper /baton-python-wrapper
WORKDIR /baton-python-wrapper
