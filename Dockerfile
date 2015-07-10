#
FROM muccg/python-base:debian8-3.4
MAINTAINER https://github.com/muccg

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  groff \
  less \
  lftp \
  rsync \
  wget \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN env --unset=DEBIAN_FRONTEND

RUN pip install awscli

COPY docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /data
USER ccg-user
ENV HOME /data

VOLUME ["/data"]

ENTRYPOINT ["/docker-entrypoint.sh"]
