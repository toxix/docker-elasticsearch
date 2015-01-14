#
# ElasticSearch Dockerfile
#
# https://github.com/toxix/docker-elasticsearch
#

# Pull base image.
FROM toxix/openjdk-jre

ENV ES_PKG_NAME elasticsearch-1.4.1

# Install curl to dowload the current elasticsearch
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -qq --no-install-recommends curl && \
  apt-get clean -qq && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

# Download and install elasticsearch
RUN \
  mkdir /elasticsearch && \
  curl -L "https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz" | \
  tar -xzC /elasticsearch --strip-components=1 && \
  rm /elasticsearch/lib/sigar/*freebsd* && \
  rm /elasticsearch/lib/sigar/*macosx* && \
  rm /elasticsearch/lib/sigar/*solaris* && \
  rm /elasticsearch/lib/sigar/*winnt* && \
  rm /elasticsearch/bin/*.exe

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
