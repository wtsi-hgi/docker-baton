FROM debian:jessie
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Add required resources
ADD install.sh /tmp
ADD patchset /tmp
RUN mkdir /scripts
WORKDIR /scripts
ADD setup.sh .

# Required environment setting
ENV PATH $PATH:/software/irods-legacy/iRODS/clients/icommands/bin
ENV LD_LIBRARY_PATH /usr/local/lib

# Setup entry script
CMD "setup.sh"
