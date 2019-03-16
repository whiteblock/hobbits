#!/bin/bash

echo "8===D"
cd ..
cd swift/
if [ -x parser ]
then 
    ./parser >> parser.txt
    cat parser.txt
    else
        swiftc -o parser parser.swift
        ./parser >> parser.txt
        cat parser.txt
fi

exit
