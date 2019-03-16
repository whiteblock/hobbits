FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt update
RUN apt install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    golang-go \
    libedit-dev \
    libxml2-dev \
    mit-scheme \
    perl \
    python \
    python-dev \
    racket \
    rustc \
    snapd \
    wget 

# install swift
RUN curl -sL https://swift.org/builds/swift-4.2.3-release/ubuntu1804/swift-4.2.3-RELEASE/swift-4.2.3-RELEASE-ubuntu18.04.tar.gz | tar -C /opt --strip 2 -xvzf -
ENV PATH "/opt/bin:$PATH"

#install dlang
RUN wget http://downloads.dlang.org/releases/2.x/2.085.0/dmd_2.085.0-0_amd64.deb && dpkg -i dmd_2.085.0-0_amd64.deb
WORKDIR /hobbits

COPY parsers/ parsers/
COPY test/ test/

WORKDIR /hobbits

RUN cd parsers && ./build.sh

RUN python test/run.py

