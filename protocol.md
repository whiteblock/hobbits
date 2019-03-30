# EWP (Ethereum Wire Protocol)

## Messages

The message type both defines the `request` and `response` as they are identical. The `message` format is the following: 

```
EWP <version> <protocol> <compression> <encoding> <headers-length> <body-length>
<header><body>
```

A parsed message would look like this:

```python
{
    'version': 'string',
    'protocol': 'string'
    'compression': 'string',
    'encoding': 'string',
    'headers': 'bytes',
    'body': 'bytes'
}
```

### Fields

| Field | Definition | Validity |
|:------:|----------|------|
| `version` | Defines the EWP version number e.g. `0.1` | Any number and `.` |
| `protocol` | Defines the communication protocol e.g. `RPC` or `GOSSIP` | Any uppercase letter or digit or _ |
| `compression` | Defines the compression codec of the `header` and `body`, none can be specified. | lowercase letters or digits or _ |
| `encoding` | Defines the encoding of the `header` and `body` | lowercase letters or digits or _ |
| `header` | Defines the header which is a `BSON` payload, it is seperately encoded and compressed. | `BSON` payload |
| `body` | Defines the body which is a `BSON` payload, it is seperately encoded and compressed. | `BSON` payload |

### Examples

example of a wire protocol message

#### RPC call example with ping
```
# Request (RPC call with a body of a RPC ping call)
EWP 0.2 RPC none json 0 26
{"id":1,"method_id":0x00}

# Response
EWP 0.2 RPC none json 0 26
{"id":1,"method_id":0x01}

```

#### RPC call with payload
```
# Request (empty headers, bson body)
EWP 0.2 RPC deflate bson 0 1234
<1234 bytes of deflate compressed binary bson body data>
# Response
EWP 0.2 RPC gzip bson 321 1234
<321 bytes of gzip compressed binary bson header data>
<1234 bytes of gzip compressed binary bson body data>

# Request (no compression, bson headers, bson body)
EWP 0.1 RPC none none 321 1234
<321 bytes of binary bson header data>
<1234 bytes of binary bson body data>
# Response
200 none 0 0\n
```

#### Gossip
```
# Request (Gossip call with a header with a message hash)
EWP 0.2 GOSSIP none json 34 0
"001322323232232932232322232327f"

# Request (Gossip call with a full block)
EWP 0.2 GOSSIP snappy bson 25 1234
<25 bytes of snappy compressed binary bson header data>
<1234 bytes of snappy compressed binary bson body data>
```

## URI designation

We use the following URI schemes for hobbits URIs:

| Secure connection | Type of connection | Scheme   |
| ----------------- | ------------------ | -------- |
| Insecure          | TCP                | hob+tcp  |
| Insecure          | UDP                | hob+udp  |
| Secure            | TCP                | hobs+tcp |
| Secure            | UDP                | hobs+udp |

Example:

```
hob+tcp://10.0.0.1:9000 // Insecure TCP
hob+udp://10.0.0.1:9000 // Insecure UDP

hobs+tcp://10.0.0.1:9000 // Secure TCP
hobs+udp://10.0.0.1:9000 // Secure UDP 
```
