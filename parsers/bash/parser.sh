#!/bin/bash

echo "8===D"
cd ..
cd swift/
swiftc -o parser parser.swift
./parser.swift