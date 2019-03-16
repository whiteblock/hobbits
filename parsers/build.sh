#!/bin/bash -xeu

pushd cpp
    make
popd

pushd d
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
    raco exe test.rkt
popd

pushd rs
    rustc parser.rs
popd

pushd scheme
    raco exe test.scm
popd

pushd swift
    swiftc parser.swift
popd
