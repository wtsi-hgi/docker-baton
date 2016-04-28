FROM ubuntu:14.04
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Add required resources
ADD install.sh /tmp/install.sh
RUN mkdir /scripts
WORKDIR /scripts
ADD setup.sh .

# Required environment setting
ENV LD_LIBRARY_PATH /usr/local/lib

# Setup entry script
ENTRYPOINT "./setup.sh"
CMD "bash"

