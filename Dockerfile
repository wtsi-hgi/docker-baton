FROM debian:jessie
MAINTAINER "hgi@sanger.ac.uk"

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    autoconf \
    gcc \
    g++ \
    perl \
    libtool \
    pkg-config \
    git \
    ca-certificates \
    automake \
    make \
    wget \
    libssl-dev

RUN mkdir /dependencies
WORKDIR dependencies

RUN git clone --depth 1 --branch 3.3.1 https://github.com/irods/irods-legacy.git
RUN git clone --depth 1 --branch 0.16.1 https://github.com/wtsi-npg/baton.git
RUN git clone --depth 1 --branch v2.6 https://github.com/akheron/jansson.git
RUN git clone --depth 1 --branch boost-1.59.0 https://github.com/boostorg/boost.git

# Build jansson
WORKDIR /dependencies/jansson
RUN autoreconf -fvi
RUN ./configure
RUN make
RUN make install

# Build iRODS
WORKDIR /dependencies/irods-legacy/iRODS
ENV IRODS_HOME /dependencies/irods-legacy/iRODS
ENV IRODS_VERSION 3.1.1
RUN sed -i '150,155d' scripts/perl/configure.pl
RUN perl scripts/perl/configure.pl
RUN sed -i '1i CFLAGS += -fPIC' lib/Makefile
RUN make libs

# Build baton
WORKDIR /dependencies/baton
RUN autoreconf -fvi
#RUN ./configure --with-irods=/dependencies/irods/iRODS

COPY . /baton-python-wrapper
WORKDIR /baton-python-wrapper
