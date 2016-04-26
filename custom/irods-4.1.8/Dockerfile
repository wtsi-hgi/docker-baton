FROM ubuntu:14.04
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Build arguments to specify baton version
#ARG REPOSITORY
#ARG BRANCH
ENV BRANCH 0.16.2
ENV REPOSITORY https://github.com/wtsi-npg/baton.git

# Run setup script
ADD install.sh /tmp/install.sh
RUN /tmp/install.sh

# Required environment setting
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Docker Hub assumes that the Dockerfile is in the project root. Therefore cannot COPY common files in without
# duplicating them in all of the version directories (Docker does not follow symlinks). Instead will get the files from
# GitHub, the downside of which is that development of the copied scripts becomes coupled to GitHub (unless this script
# is changed so that files under development are imported using COPY).
RUN git clone --depth 1 https://github.com/wtsi-hgi/docker-baton.git /tmp/docker-baton
RUN cp /tmp/docker-baton/setup.sh /setup.sh

# Setup entry script
CMD "/scripts/setup.sh"
