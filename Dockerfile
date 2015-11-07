#
# CoreOS application initialization and configuration base docker image
#
# http://github.com/tenstartups/coreos-parasite-base-docker
#

FROM tenstartups/alpine-ruby:latest

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment
ENV \
  HOME=/home/parasite \
  RUBYLIB=/home/parasite/lib

# Install gems.
RUN gem install --no-ri --no-rdoc httparty

# Set the working directory.
WORKDIR "/home/parasite"

# Add files to the container.
COPY conf.d conf.d
COPY lib lib
COPY entrypoint.rb /docker-entrypoint
# The directory name under the parasite directory must match the name of the conf.d script
COPY host 10-base/host

# Set the entrypoint script.
ENTRYPOINT ["/docker-entrypoint"]

# Set the default command
CMD ["/bin/bash"]

# Dump out the git revision.
ONBUILD COPY .git/HEAD .git/HEAD
ONBUILD COPY .git/refs/heads .git/refs/heads
ONBUILD RUN \
  cat ".git/$(cat .git/HEAD 2>/dev/null | sed -E 's/ref: (.+)/\1/')" 2>/dev/null > ./REVISION && \
  rm -rf ./.git
