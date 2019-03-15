#!/bin/bash -xeu

pushd cpp
    make
popd

pushd go
    go build parser.go
popd

# N/A
#pushd js
#popd

# N/A
#pushd php
#popd

# N/A
#pushd python
#popd

pushd racket
popd

pushd rs
popd

pushd scheme
popd

pushd swift
popd
