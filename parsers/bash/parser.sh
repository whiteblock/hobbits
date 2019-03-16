#!/bin/bash

echo "8===D"
cd ..
cd swift/
if [ -x parser.swift ]
then 
    ./parser
    else
        swiftc -o parser parser.swift
        ./parser
fi
exit
