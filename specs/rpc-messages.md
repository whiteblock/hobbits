# Messages

These messages are used to define an application protocol for Ethereum 2.0.
These messages define a RPC protocol for clients to interact with each other.

# Envelope

This application protocol is classified under the `RPC` command.

All messages of the command RPC use BSON serialization and snappy compression.

The body of the RPC calls must conform to:
```
{ 
  method_id: uint16 // byte representing the method
  id: uint64 // id of the request
  body: // body of the request itself
}
```

Example (showing the bson snappy data as json):
```
EWP 0.2 RPC 0 12
{
  "method_id": 0x01,
  "id": 1,
  "body": {
    "reason": 42
  }
}
```

The message may contain additional headers specified by the application layer.

## `0x00` HELLO

Nodes can send `HELLO` messages to each other to exchange information on their status.


```java
{
  'network_id': 'uint8' // the ID of the network (1 for mainnet, and some predefined number for a testnet)
  'chain_id': 'uint8' // the ID of the chain (1 for ETH)
  'latest_finalized_root': 'bytes32' // the hash of the latest finalized root
  'latest_finalized_epoch': 'uint64' // the number of the latest finalized epoch
  'best_root': 'bytes32' // the hash of the best root this node can offer
  'best_slot': 'uint64' // the number of the best slot this node can offer
}
```

## `0x01` GOODBYE

Nodes may signal to other nodes that they are going away by sending a `GOODBYE` message.
The reason given is optional. Reason codes are up to each client and should not be trusted.

```java
{
  'reason': 'uint64' // an optional reason code up to the client
}

```

## `0x02` GET_STATUS

Nodes may exchange metadata information using a `GET_STATUS` message.

This information is useful to identify other nodes and clients and report that information to statistics services.

```java
{
  'user_agent': 'bytes' // the human readable name of the client, optionally with its version and other metadata
  'timestamp': 'uint64' // the current time of the node in milliseconds since epoch
}
```

## `0x0A` GET_BLOCK_HEADERS

Nodes may request block headers from other nodes using the `GET_BLOCK_HEADERS` message.

```java
{
  'start_root': 'bytes32' // the root hash to start querying from OR
  'start_slot': 'uint64' // the slot number to start querying from
  'max': 'uint64' // the max number of elements to return
  'skip': 'uint64' // the number of elements apart to pick from
  'direction': 'uint8' // 0x01 is ascending, 0x00 is descending direction to query elements
}
```

The request should contain either a `start_root` or `start_slot` parameter.

## `0x0B` BLOCK_HEADERS

Nodes may provide block roots to other nodes using the `BLOCK_HEADERS` message, usually in response to a `GET_BLOCK_HEADERS` message.

```java
  'headers': '[]BeaconBlockHeader'
```

## `0x0C`  GET_BLOCK_BODIES

Nodes may request block bodies from other nodes using the `GET_BLOCK_BODIES` message.

```java
{
  'start_root': 'bytes32' // the root hash to start querying from OR
  'start_slot': 'uint64' // the slot number to start querying from
  'max': 'uint64' // the max number of elements to return
  'skip': 'uint64' // the number of elements apart to pick from
  'direction': 'uint8' // 0x01 is ascending, 0x00 is descending direction to query elements
}
```

The request should contain either a `start_root` or `start_slot` parameter.

## `0x0D`  BLOCK_BODIES

Nodes may provide block roots to other nodes using the `BLOCK_BODIES` message, usually in response to a `GET_BLOCK_BODIES` message.

```java
[
  {
      'randao_reveal': 'bytes96',
      'eth1_data': Eth1Data,
      'proposer_slashings': [ProposerSlashing],
      'attester_slashings': [AttesterSlashing],
      'attestations': [Attestation],
      'deposits': [Deposit],
      'voluntary_exits': [VoluntaryExit],
      'transfers': [Transfer],
      'header_signature:' 'bytes96'
  }
]
```

# Lifecycle and message exchanges

## Initial hello

Upon discovering each other, nodes may exchange `HELLO` messages.

Nodes may send `HELLO` to other peers when they exchange messages for the first time or when their state changes to let them know new blocks are available.

Upon receiving a `HELLO` message, the node may reply with a `HELLO` message.

## Status messages

Any peer may provide information about their status and metadata to any other peer. Other peers may respond on a best effort basis, if at all.

## Block and header messages

Peers may request blocks and headers from other peers.

Other peers may respond on a best effort basis with header and block data.

There is no SLA for responding. Peers may request blocks repeatedly from the same peers.

#### The following definitions are aligned to v0.5.0 of the Beacon Chain Spec:

- [ProposerSlashing](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#proposerslashing)  
- [AttesterSlashing](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#attesterslashing)  
- [Attestation](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#attestation)  
- [Deposit](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#deposit)  
- [VoluntaryExit](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#voluntaryexit)  
- [Transfer](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#transfer)
- [Eth1Data](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#eth1data)


