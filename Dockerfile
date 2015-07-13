FROM ubuntu:14.04

RUN apt-get update && apt-get install --assume-yes \
    build-essential \
    automake1.9 \
    perl \
    python \
    libgsl0-dev \
    libffi-dev \
    libgmp3-dev \
    texinfo

RUN useradd --create-home --home-dir /opt/church --shell /bin/bash church
ENV HOME /opt/church
ENV USER church

WORKDIR /opt/church

# vicare
ADD https://github.com/marcomaggi/vicare/archive/08bd828acfa9382324150b41f4e86c540c10a886.tar.gz vicare.tar.gz
RUN tar -xvf vicare.tar.gz && ln -s vicare-08bd828acfa9382324150b41f4e86c540c10a886 vicare
RUN cd vicare && \
    sh BUILD-THE-INFRASTRUCTURE.sh && \
    ./configure --enable-libffi && make && make install

# scheme-tools
ADD https://github.com/stuhlmueller/scheme-tools/archive/master.tar.gz scheme-tools-master.tar.gz
RUN tar -xvf scheme-tools-master.tar.gz && ln -s ../scheme-tools-master vicare/scheme-tools

# bher
COPY bher /opt/church/vicare/bher

RUN chown -R church:church /opt/church
ENV VICARE_LIBRARY_PATH /opt/church/vicare:/opt/church/vicare/bher:/opt/church/vicare/scheme-tools
ENV PATH /opt/church/vicare/bher:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

USER church
