FROM debian:jessie
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

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
    libssl-dev \
    jq \
    perl-doc

# Build arguments
ARG BRANCH
ARG REPOSITORY

# Environment variables for use in build
ENV SOFTWARE /software
ENV IRODS $SOFTWARE/irods-legacy/iRODS
ENV JANSSON $SOFTWARE/jansson
ENV BATON $SOFTWARE/baton
ENV PATCHSET /patchset
ENV IRODS_SETTINGS /root/.irods/.irodsEnv
ENV SCRIPTS /scripts

# Environment variables used by software
ENV IRODS_HOME $IRODS
ENV IRODS_VERSION 3.3.1
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Docker Hub assumes that the Dockerfile is in the project root. Therefore cannot COPY common files in without
# duplicating them in all of the version directories (Docker does not follow symlinks). Instead will get the files from
# GitHub, the downside of which is that development of the copied scripts becomes coupled to GitHub (unless this script
# is changed so that files under development are imported using COPY).
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/wtsi-hgi/docker-baton.git
RUN cp -r docker-baton/patchset $PATCHSET
RUN mkdir $SCRIPTS
RUN cp docker-baton/setup.sh $SCRIPTS/setup.sh

# Fetch dependencies
RUN mkdir $SOFTWARE
WORKDIR $SOFTWARE
RUN git clone --depth 1 --branch $IRODS_VERSION https://github.com/irods/irods-legacy.git
RUN git clone --depth 1 --branch v2.6 https://github.com/akheron/jansson.git
RUN git clone --depth 1 --branch $BRANCH $REPOSITORY

# baton also requires a bunch of Perl modules
RUN cpanm JSON List::AllUtils

# Patch and Build iRODS
WORKDIR $IRODS
RUN patch scripts/perl/configure.pl $PATCHSET/iRODS-configure.diff
RUN patch lib/Makefile $PATCHSET/iRODS-lib-Makefile.diff
RUN perl scripts/perl/configure.pl
RUN make libs
# icommands are not required for baton but may be useful in debugging iRODS
# server connection issues
RUN make icommands
ENV PATH $PATH:$IRODS/clients/icommands/bin

# Build jansson
WORKDIR $JANSSON
RUN autoreconf -fvi
RUN ./configure
RUN make
RUN make install

# Build baton
WORKDIR $BATON
RUN autoreconf -fvi
RUN ./configure --with-irods=$IRODS_HOME
RUN make
RUN make install

# Make settings folder for baton/iRODs
RUN mkdir -p $(dirname $IRODS_SETTINGS)

# Setup entry script
WORKDIR $SCRIPTS
ENTRYPOINT ["./setup.sh"]
CMD ["bash"]
