# Hobbits, or There and Back Again: A Lightweight, Multiclient Wire Protocol For Web3 Communications

## Contributing

Please create issues to document your critiques, suggestions, improvements, etc. We will use it as a discussion funnel to refine this specification and move forward towards a stable 1.0

## 0.1 EWP (Ethereum Wire Protocol)

#### types

##### `request`

```python
{
    'version': 'string',
    'command': 'string',
    'compression': 'string',
    'response_compression': '[string]',
    'head_only_indicator': 'bool',
    'headers': 'bytes',
    'body': 'bytes'
}
```

##### `response`

```python
{
    'code': 'uint16',
    'compression': 'string',
    'headers': 'bytes',
    'body': 'bytes'
}
```

#### command
may contain any uppercase letter or digit or _  to describe the command

#### compression preference
the first preference field is describing the compression codec of the request headers & body in all lowercase letters or digits or _

the second preference field is the list of supported compression codecs for the response in order from most preferred to least preferred separated by commas and preferences in all lowercase letters or digits or _

none can be specified to indicate no compression is to be used on the header or body data.

#### headers and body
headers and body are both BSON data payloads which are separately compressed and encoded -- the idea is to keep the headers lightweight so packets can be partially processed without having to decode the whole body in every case.

#### missing languages
  * brainfuck
  * bash
  * perl
  * x86 asm
  * ruby
  * ada
  * c
  * d
  * css3
 
### examples

example of a wire protocol message

#### ping
```
# Request (empty headers and body)
EWP 0.1 PING none none 0 0

# Response
200 none 0 0

```

#### hello
```
# Request (empty headers, bson body)
EWP 0.1 HELLO deflate gzip,snappy 0 1234
<1234 bytes of deflate compressed binary bson body data>
# Response
200 gzip 321 1234
<321 bytes of gzip compressed binary bson header data>
<1234 bytes of gzip compressed binary bson body data>

# Request (no compression, bson headers, bson body)
EWP 0.1 HELLO none none 321 1234
<321 bytes of binary bson header data>
<1234 bytes of binary bson body data>
# Response
200 none 0 0
```

## Running Tests

```
python test/run.sh
```
