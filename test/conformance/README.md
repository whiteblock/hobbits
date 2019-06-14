# Conformance testing application

This folder contains a simple go application one can use to ensure their
implementation of hobbits is able to expose a port and accept incoming TCP connections, as well as consume a hobbits message.

Usage:
```bash
$> conformance <host:-0.0.0.0> <port:-9000>
```

Build:

The build requires Go 1.11 or later to be installed on the machine.

Get all dependencies:
```
go get
```
Build the program for your platform:
```
go build
```