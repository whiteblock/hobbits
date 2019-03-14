# Hobbits, or There and Back Again: A Lightweight, Multiclient Wire Protocol For Web3 Communications

## Contributing

Please create issues to document your critiques, suggestions, improvements, etc. We will use it as a discussion funnel to refine this specification and move forward towards a stable 1.0

## 0.1 EWP (Ethereum Wire Protocol)

### examples

example of a wire protocol message

#### ping
```
# Request (empty headers and body)
EWP 0.1 PING snappy,gzip,deflate 0 0

# Response
200 snappy 0 0

```

#### hello
```
# Request (empty headers, bson body)
EWP 0.1 HELLO deflate,gzip,snappy 0 1234
<1234 bytes of binary bson body data>
# Response
200 deflate 0 0

```
