# Messages
These messages are used to define a gossip protocol for Ethereum 2.0. These messages define a gossip protocol for clients to replicate information with each other.

# Serialization and compression

All messages of the command GOSSIP use SSZ serialization and snappy compression.

# Envelope
All messages follow the envelope standard to Hobbits as described in [protocol.md].

This application protocol is classified under the `GOSSIP` command.

The message must contain the following headers:

| Header name | Type | Notes |
|-------------|------|-------|
| method_id   | uint8| the method used in this exchange, as described below |
| message_type | uint8| the type of message being exachanged, as described below |
| message_hash | bytes32 | a hash uniquely representing the message contents, with a hash function up to the application |
| hash_signature | bytes32 | a signature of the message hash with a public key identifying the node sending data |

Example (showing the ssz snappy data as json):

```java
EWP 0.2 GOSSIP 24 0
{
  "method_id": 3,
  "message_type": 0,
  "message_hash": "0x9D686F6262697473206172652074776F20616E6420666F75722066656574",
  "hash_signature": "0x0000000009A4672656E63682070656F706C6520617265207468652062657374"
}
```

The message may contain additional headers specified by the application layer.

# Methods

## 0x00 GOSSIP

Nodes use `GOSSIP` methods to send data to other nodes in the network.

The body of a `GOSSIP` method consists in the data being gossiped.

The `message_hash` header value must match the hash of the contents of the body according to a predefined hash function defined by the application.

## 0x01 PRUNE

Nodes use `PRUNE` messages to inform other nodes that they are removed from the list of peers that will receive data from them.
Instead of sending data, nodes will send attestations as `IHAVE` messages.

The header may contain the `message_hash` of a message that triggered the pruning.

## 0x02 GRAFT

Nodes use `PRUNE` messages to inform other nodes that they are added to the list of peers that will receive data from them.
Instead of sending attestations as `IHAVE` messages, nodes will send data as `GOSSIP` messages.

No body is present in `GRAFT` messages.

The header may contain the `message_hash` of a message triggered the graft.

Targets should reply with a `GOSSIP` message sending the message matching the hash.

## 0x03 IHAVE

Nodes use `IHAVE` messages to inform other nodes that they are in possession of data that matches the signature they are sending.

No body is present in `IHAVE` messages.

The header must contain the `message_hash` with the value of the hash of the data attested by the peer.

# Message Types

GOSSIP allows to gossip different types of payloads. To differentiate them, it uses a header `message_type`.

## 0x00 BLOCK
[Block](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#beaconblock) - from v0.5.1 of the BeaconChain spec
## 0x01 ATTESTATION
[Attestation](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#attestation) - from v0.5.1 of the BeaconChain spec
