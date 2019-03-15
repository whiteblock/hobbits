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
    raco exe hobbit.rkt
popd

pushd rs
    rustc parser.rs
popd

pushd scheme
    cf hobbit.scm
popd

pushd swift
    swiftc parser.swift
popd
