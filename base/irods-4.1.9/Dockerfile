FROM ubuntu:14.04
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Add required resources
ADD install.sh /tmp/install.sh
RUN mkdir /scripts
WORKDIR /scripts
ADD setup.sh .
ADD write-settings.sh .

# Required environment setting
ENV IRODS_SETTINGS /root/.irods/irods_environment.json
ENV LD_LIBRARY_PATH /usr/local/lib

# Install pre-requisits
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
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
