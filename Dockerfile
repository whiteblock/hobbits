FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    golang-go \
    libedit-dev \
    libxml2-dev \
    mit-scheme \
    perl \
    php \
    python \
    python-dev \
    python-yaml \
    racket \
    rustc \
    snapd \
    wget \
    erlang \
    haskell-platform \
    clisp-dev \
    cl-quicklisp \
    openjdk-11-jre

WORKDIR /tmp

# install swift
RUN curl -sL https://swift.org/builds/swift-4.2.3-release/ubuntu1804/swift-4.2.3-RELEASE/swift-4.2.3-RELEASE-ubuntu18.04.tar.gz | tar -C / --strip 1 -xvzf -

#install dlang
RUN wget http://downloads.dlang.org/releases/2.x/2.085.0/dmd_2.085.0-0_amd64.deb && dpkg -i dmd_2.085.0-0_amd64.deb

WORKDIR /hobbits

COPY parsers/ parsers/
COPY test/ test/

WORKDIR /hobbits

RUN cd parsers && ./build.sh

ENV RUST_BACKTRACE=full

CMD python test/run.py

