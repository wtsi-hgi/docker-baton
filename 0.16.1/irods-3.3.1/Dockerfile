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

# Our changes required to compile
COPY patchset $PATCHSET

# Fetch dependencies
RUN mkdir $SOFTWARE
WORKDIR $SOFTWARE
RUN git clone --depth 1 --branch $IRODS_VERSION https://github.com/irods/irods-legacy.git
RUN git clone --depth 1 --branch v2.6 https://github.com/akheron/jansson.git
RUN git clone --depth 1 --branch 0.16.1 https://github.com/wtsi-npg/baton.git

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
RUN mkdir $SCRIPTS
WORKDIR $SCRIPTS
COPY setup.sh setup.sh
ENTRYPOINT ["./setup.sh"]
CMD ["bash"]
