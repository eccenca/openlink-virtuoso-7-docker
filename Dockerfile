####
#
# Dockerfile for building an OpenLink Virtuoso Opensource from git.
# Virtuoso config is provided here.
#
# Installation is in /opt/virtuoso-opensource, the database files reside in /data/
####

FROM eccenca/baseimage:1.0.1
MAINTAINER Rene Pietzsch <rene.pietzsch@eccenca.com>
MAINTAINER Henri Knochehauer <henri.knochenhauer@eccenca.com>

ENV VIRT_HOME /opt/virtuoso-opensource
ENV VIRT_INI_TEMPLATE /var/lib/virtuoso/virtuoso_template.ini
ENV VIRT_DB /data
ENV VIRTUOSO_VERSION v7.2.4.2

ENV DEBIAN_FRONTEND noninteractive

RUN \
      apt-get -y update \
   && apt-get -y upgrade\
   && apt-get -y install --no-install-recommends \
      autoconf \
      automake \
      bison \
      build-essential \
      dpkg-dev \
      flex \
      gawk \
      git\
      gperf \
      libreadline-dev \
      libssl-dev \
      libtool \
      m4 \
      make \
      openssl \
    && git clone --recursive https://github.com/openlink/virtuoso-opensource.git /opt/virtuoso-opensource.src \
    && cd /opt/virtuoso-opensource.src \
    && git checkout ${VIRTUOSO_VERSION} \
    && ./autogen.sh \
    && CFLAGS="-O2 -m64" ./configure --prefix=/opt/virtuoso-opensource --with-readline \
    && make -j 8 \
    && make install  \
    && ln -s /opt/virtuoso-opensource/bin/isql /usr/bin/isql \
    && rm -rf /opt/virtuoso-opensource.src \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p "${VIRT_DB}"

COPY virtuoso.ini "${VIRT_INI_TEMPLATE}"
COPY ./my_init.d /etc/my_init.d
COPY ./svc /etc/service

COPY assets/virtuoso_helper.sh "${VIRT_HOME}/virtuoso_helper.sh"
RUN chmod +x "${VIRT_HOME}/virtuoso_helper.sh"

EXPOSE 1111
EXPOSE 80
VOLUME ["/data"]
WORKDIR /data
CMD ["/sbin/my_init"]
