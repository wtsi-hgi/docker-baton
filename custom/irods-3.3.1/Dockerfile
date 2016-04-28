FROM mercury/baton:base-for-baton-with-irods-3.3.1
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Build arguments to specify baton version
ARG REPOSITORY
ARG BRANCH

# Run setup script
RUN /tmp/install.sh $REPOSITORY $BRANCH
