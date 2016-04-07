FROM debian:jessie
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Specify baton version
ENV REPOSITORY https://github.com/wtsi-npg/baton.git
ENV BRANCH 0.16.2

# Run setup script
# XXX: Dockerhub expects all required build content to be within the same directory as the Dockerfile - there is no -f
# option! Therefore, either install.sh is replicated for each version or this horrible solution is used. The summary is
# that DockerHub was not designed to be used in the intended way.
ADD https://raw.githubusercontent.com/wtsi-hgi/docker-baton/master/custom/irods-3.3.1/install.sh /tmp
RUN chmod 700 /tmp/install.sh
RUN /tmp/install.sh

# Required environment setting
# TODO: There is probably a better way of capturing these from the install script
ENV IRODS_SETTINGS /root/.irods/.irodsEnv
ENV PATH $PATH:/software/irods-legacy/iRODS/clients/icommands/bin

# Setup entry script
ENTRYPOINT ["/scripts/setup.sh"]
CMD ["bash"]
