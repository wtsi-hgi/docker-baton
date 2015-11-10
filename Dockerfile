FROM debian:jessie
MAINTAINER "hgi@sanger.ac.uk"

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    autoconf \
    gcc \
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

#RUN git clone --depth 1 --branch 4.1.6 https://github.com/irods/irods.git
RUN git clone --depth 1 --branch 0.16.1 https://github.com/wtsi-npg/baton.git
RUN git clone --depth 1 --branch v2.6 https://github.com/akheron/jansson.git
RUN git clone --depth 1 --branch boost-1.59.0 https://github.com/boostorg/boost.git

# Build jansson
WORKDIR /dependencies/jansson
RUN autoreconf -fvi
RUN ./configure
RUN make
RUN make install

# Get iRODS
RUN mkdir /dependencies/irods
WORKDIR /dependencies/irods
RUN wget https://github.com/wtsi-npg/irods-legacy/releases/download/3.3.1-travis-bc85aa/irods.tar.gz
RUN tar xfz irods.tar.gz
RUN rm irods.tar.gz


# Build baton
WORKDIR /dependencies/baton
RUN autoreconf -fvi
#RUN ./configure --with-irods=/dependencies/irods/iRODS

COPY . /baton-python-wrapper
WORKDIR /baton-python-wrapper


