# EWP (Ethereum Wire Protocol)

## types

### `message`

```python
{
    'protocol': 'string'
    'version': 'string',
    'compression': 'string',
    'encoding': 'string',
    'head_only_indicator': 'bool',
    'headers': 'bytes',
    'body': 'bytes'
}
```

## command
may contain any uppercase letter or digit or _  to describe the command

## compression
the compression field is describing the compression codec of the request headers & body in all lowercase letters or digits or _

none can be specified to indicate no compression is to be used on the header or body data.

## encoding

the encoding field describes the encoding used by the headers and body in all lowercase letters or digits or _

## headers and body
headers and body are both BSON data payloads which are separately compressed and encoded -- the idea is to keep the headers lightweight so packets can be partially processed without having to decode the whole body in every case.

## examples

example of a wire protocol message

### RPC call example with ping
```
# Request (RPC call with a body of a RPC ping call)
EWP 0.2 RPC none json 0 26
{"id":1,"method_id":0x00}

# Response
EWP 0.2 RPC none json 0 26
{"id":1,"method_id":0x01}

```

### RPC call with payload
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

### Gossip
```
# Request (Gossip call with a header with a message hash)
EWP 0.2 GOSSIP none json 34 0
"001322323232232932232322232327f"

# Request (Gossip call with a full block)
EWP 0.2 GOSSIP snappy bson 25 1234
<25 bytes of snappy compressed binary bson header data>
<1234 bytes of snappy compressed binary bson body data>
```

# URI designation

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