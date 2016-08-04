FROM debian:jessie
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Add required resources
ADD install.sh /tmp
ADD patchset /tmp/patchset
RUN mkdir /scripts
WORKDIR /scripts
ADD setup.sh .
ADD write-settings.sh .

# Required environment setting
ENV IRODS_SETTINGS /root/.irods/.irodsEnv
ENV PATH ${PATH}:/software/irods-legacy/iRODS/clients/icommands/bin
ENV LD_LIBRARY_PATH /usr/local/lib

# Install prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# Setup entry script
ENTRYPOINT ["./setup.sh"]
CMD ["bash"]
