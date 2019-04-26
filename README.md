# Hobbits, or There and Back Again

A Lightweight, Multiclient Wire Protocol For ETH2.0 Communications

Hobbits is a modular wire protocol which allows implementers to experiment with various application logic over a practical network in an agnostic and expedient manner.   

## Specifications

### EWP 0.2
 - [EBNF Grammar](/specs/Ethereum-Wire-Protocol-0.2.EBNF)
 - [Protocol](/specs/protocol.md)
 
### ETH 2.0 Protocol
 - [Messages](/specs/rpc-messages.md)

## Implementations

### Demo Implementations
 - [C](/parsers/c)
 - [C++](/parsers/cpp)
 - [Common Lisp](/parsers/clisp)
 - [D](/parsers/d)
 - [Erlang](/parsers/erlang)
 - [Go](/parsers/go)
 - [Java](/parsers/java)
 - [Javascript](/parsers/js)
 - [Perl](/parsers/perl)
 - [PHP](/parsers/php)
 - [Python](/parsers/python)
 - [Racket](/parsers/racket)
 - [Rust](/parsers/rs)
 - [Scheme](/parsers/scheme)
 - [Swift](/parsers/swift)
 - [Bash](/parsers/bash)
 - [Ruby](/parsers/ruby)

### Full Implementations
 - [Java](https://github.com/pegasyseng/artemis)
 - [Swift](https://github.com/yeeth/Hobbits.swift)

### Missing languages
  * brainfuck
  * x86 asm
  * ada
  * css3

## Setup

```bash
sh setup.sh
```
 
## Running Tests

```
python test/run.py
```
> Note: This chicken shit python test runner is written in python 2.


Basic [benchmark results](https://gist.github.com/prestonvanloon/6663510164f967fa05553ead157cd5c1) against Protobuf. 

## Contributing

Please create issues to document your critiques, suggestions, improvements, etc. We will use it as a discussion funnel to refine this specification and move forward towards a stable 1.0

STEAL THIS CODE
