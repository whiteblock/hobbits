#!/bin/bash -xeu

pushd c
    make re
popd

pushd clisp
    clisp -i "~/quicklisp/setup.lisp" -i init.lisp -c hobbit.lisp
popd

pushd cpp
    make
popd

pushd d
    make
popd

pushd erlang
    erl -compile ewp_request.erl ewp_response.erl
popd

pushd go
    go get || true
    go build
    mv ./go ./test
popd

# N/A
#pushd js
#popd

pushd perl
    prove -v parser.t
popd

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

#pushd swift
#    swiftc parser.swift
#popd
