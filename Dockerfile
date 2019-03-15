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

WORKDIR /hobbits

COPY parsers/ parsers/
COPY test/ test/

WORKDIR /hobbits

RUN ./build.sh

RUN python test/run.py
