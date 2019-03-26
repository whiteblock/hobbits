# Messages

These messages are used to define an application protocol for Ethereum 2.0.
These messages define a RPC protocol for clients to interact with each other.

# Envelope

All messages follow the envelope standard to Hobbits as described in [protocol.md].

This application protocol is classified under the `RPC` command.

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
EWP 0.2 RPC snappy bson 0 12
{
  "method_id": 0x00,
  "id": 1,
  "body": {
    "reason": 42
  }
}
```

## `0x00` HELLO

```python
{
  'network_id': 'uint8'
  'chain_id': 'uint8'
  'latest_finalized_root': 'bytes32'
  'latest_finalized_epoch': 'uint64'
  'best_root': 'bytes32'
  'best_slot': 'uint64'
}
```

## `0x01` GOODBYE

```python
{
  'reason': 'uint64'
}

```

## `0x02` GET_STATUS
```python
{
  'sha': 'bytes32'
  'user_agent': 'bytes'
  'timestamp': 'uint64'
}
```

## `0x0A` GET_BLOCK_ROOTS

```python
{
  'start_root': 'bytes32'
  'start_slot': 'uint64'
  'max': 'uint64'
  'skip': 'uint64'
  'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
}
```

### `0x0B` BLOCK_ROOTS

```python
[
  {
    'block_root': 'bytes32', 
    'slot': 'uint64'
  },
  ...
]
```


## `0x0C` GET_BLOCK_HEADERS

```python
{
  'start_root': 'bytes32'
  'start_slot': 'uint64'
  'max': 'uint64'
  'skip': 'uint64'
  'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
}
```

## `0x0D` BLOCK_HEADERS

```python
  'headers': '[]BeaconBlockHeader'
```


## `0x0E`  GET_BLOCK_BODIES

```python
[
  {
    'start_root': 'bytes32'
    'start_slot': 'uint64'
    'max': 'uint64'
    'skip': 'uint64'
    'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
  }
]
```

## `0x0F`  BLOCK_BODIES

```python
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

#### The following definitions are aligned to v0.5.0 of the Beacon Chain Spec:

- [ProposerSlashing](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#proposerslashing)  
- [AttesterSlashing](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#attesterslashing)  
- [Attestation](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#attestation)  
- [Deposit](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#deposit)  
- [VoluntaryExit](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#voluntaryexit)  
- [Transfer](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#transfer)
- [Eth1Data](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#eth1data)


