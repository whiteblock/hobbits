# URI

General form:

`<scheme>://<identity>@<host>:<port>`

## Scheme

We use the following URI schemes for hobbits URIs:

| Secure connection | Type of connection | Scheme    |
| ----------------- | ------------------ | --------- |
| Insecure          | Persistent TCP     | hob+tcp   |
| Insecure          | UDP                | hob+udp   |
| TLS               | TCP                | hob+tls   |
| TLS               | UDP                | hobs+dtls |
| RLPx              | Persistent TCP     | hob+rlpx  |
| Insecure          | HTTP               | hob+http  |
| TLS               | HTTPs              | hob+https |
| TLS               | Web socket         | hob+ws    |
| Secure Scuttlebutt| Persistent TCP     | hob+ssb   |

Example:

```
hob+tcp://10.0.0.1:9000 // Insecure persistent TCP
hob+udp://10.0.0.1:9000 // Insecure UDP

hob+tls://10.0.0.1:9000 // TLS TCP
hob+dtls://10.0.0.1:9000 // TLS UDP 
```

## Identity

The user information part of the URI is used to store the public key of the peer if the connection is made over RLPx or Secure Scuttlebutt.

With RLPx, the user information is a 64 bytes long hexadecimal string representing the SECP256K1 public key.

With Secure Scuttlebutt, the user information is the base64-encoded representation of the Ed25519 public key of the peer.

## Host

The host to connect to - either a DNS-resolved hostname or an IP.

## Port

An integer between 1 and 65535.