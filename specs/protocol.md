# EWP (Ethereum Wire Protocol)

## Messages

The message type both defines the `request` and `response` as they are identical. The `message` format is the following: 

```
EWP <version> <protocol> <headers-length> <body-length>
<header><body>
```

A parsed message would look like this:

```python
{
    'version': 'string',
    'protocol': 'string'
    'header': 'bytes',
    'body': 'bytes'
}
```

### Fields

| Field | Definition | Validity |
|:------:|----------|:----:|
| `version` | Defines the EWP version number e.g. `0.2`. | `(\d+\.)(\d+)` |
| `protocol` | Defines the communication protocol. | `(RPC\|GOSSIP)` |
| `header` | Defines the header | payload |
| `body` | Defines the body | payload |

### Examples

example of a wire protocol message

#### RPC call example with ping
```
# Request (RPC call with a body of a RPC ping call)
EWP 0.2 RPC 0 25
{"id":1,"method_id":0x00}

# Response
EWP 0.2 RPC 0 25
{"id":1,"method_id":0x01}
```

#### RPC call with payload
```
# Request
EWP 0.2 RPC 0 1234
<1234 bytes of deflate compressed binary bson body data>
# Response
EWP 0.2 RPC 321 1234
<321 bytes of gzip compressed binary bson header data>
<1234 bytes of gzip compressed binary bson body data>
```

#### Gossip
```
# Request (Gossip call with a full block)
EWP 0.2 GOSSIP 25 1234
<25 bytes of header data>
<1234 bytes of body data>
```

