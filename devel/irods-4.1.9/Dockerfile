FROM mercury/baton:base-for-baton-with-irods-4.1.9
MAINTAINER "Colin Nolan" <hgi@sanger.ac.uk>

# Specify baton version
ENV REPOSITORY https://github.com/wtsi-npg/baton.git
ENV BRANCH devel

# Run setup script
RUN /tmp/install.sh ${REPOSITORY} ${BRANCH}
