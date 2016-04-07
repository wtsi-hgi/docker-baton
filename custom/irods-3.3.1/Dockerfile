FROM debian:jessie
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Build arguments to specify baton version
ARG REPOSITORY
ARG BRANCH

# Run setup script
ADD custom/irods-3.3.1/install.sh /tmp
RUN /tmp/install.sh

# Required environment setting
# TODO: There is probably a better way of capturing these from the install script
ENV IRODS_SETTINGS /root/.irods/.irodsEnv
ENV PATH $PATH:/software/irods-legacy/iRODS/clients/icommands/bin

# Setup entry script
ENTRYPOINT ["/scripts/setup.sh"]
CMD ["bash"]
