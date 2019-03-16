#!/bin/bash

echo "8===D"
cd ..
cd swift/
swiftc -o parser parser.swift
chmod +x parser.swift
./parser.swift