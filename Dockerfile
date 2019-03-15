FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt update
RUN apt install -y --no-install-recommends \
    perl \
    python
