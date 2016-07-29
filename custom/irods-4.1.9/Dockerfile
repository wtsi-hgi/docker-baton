FROM mercury/baton:base-for-baton-with-irods-4.1.9
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Build arguments to specify baton version
ARG REPOSITORY
ARG BRANCH

# Run setup script
RUN /tmp/install.sh $REPOSITORY $BRANCH
