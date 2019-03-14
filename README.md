# Hobbits, or There and Back Again: A Lightweight, Multiclient Wire Protocol For Web3 Communications

## Contributing

Please create issues to document your critiques, suggestions, improvements, etc. We will use it as a discussion funnel to refine this specification and move forward towards a stable 1.0

## 0.1 EWP (Ethereum Wire Protocol)
#### command
any uppercase letters and _ to describe the command

#### compression preference
list of supported compression codecs for the response in order from most preferred to least preferred separated by commas and all lowercase letters

the first item in the preference list is assumed to be the request header and body compression codec

none can be specified to indicate no compression is to be used on the header or body data.

#### headers and body
headers and body are both BSON data payloads which are separately compressed and encoded -- the idea is to keep the headers lightweight so packets can be partially processed without having to decode the whole body in every case.

### examples

example of a wire protocol message

#### ping
```
# Request (empty headers and body)
EWP 0.1 PING none 0 0

# Response
200 none 0 0

```

#### hello
```
# Request (empty headers, bson body)
EWP 0.1 HELLO deflate,gzip,snappy 0 1234
<1234 bytes of deflate compressed binary bson body data>
# Response
200 deflate 0 0

# Request (no compression, bson headers, bson body)
EWP 0.1 HELLO none 321 1234
<321 bytes of binary bson body data>
<1234 bytes of binary bson body data>
# Response
200 none 0 0
```
