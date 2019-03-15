FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt update
RUN apt install -y --no-install-recommends \
    build-essential \
    golang-go \
    mit-scheme \
    perl \
    python \
    racket \
    rustc \
    swift

WORKDIR /hobbit

COPY parsers/ parsers/

WORKDIR /hobbit/parsers

RUN ./build.sh

