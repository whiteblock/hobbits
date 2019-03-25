# Messages

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

## `0x0A` BLOCK_ROOTS


### Request

```python
{
  'start_root': 'bytes32'
  'start_slot': 'uint64'
  'max': 'uint64'
  'skip': 'uint64'
  'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
}
```

### Response

```python
[
  {
    'block_root': 'bytes32', 
    'slot': 'uint64'
  },
  ...
]
```


## `0x0B` BEACON_BLOCK_HEADERS

### Request

```python
{
  'start_root': 'bytes32'
  'start_slot': 'uint64'
  'max': 'uint64'
  'skip': 'uint64'
  'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
}
```

### Response 
```python
  'headers': '[]BeaconBlockHeader'
```


## `0x0C`  BLOCK_BODIES

### Request

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

### Response

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

#### The following definitions are lined to v0.5.0 of the Beacon Chain Spec:

- [ProposerSlashing](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#proposerslashing)  
- [AttesterSlashing](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#attesterslashing)  
- [Attestation](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#attestation)  
- [Deposit](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#deposit)  
- [VoluntaryExit](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#voluntaryexit)  
- [Transfer](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#transfer)
- [Eth1Data](https://github.com/ethereum/eth2.0-specs/blob/v0.5.0/specs/core/0_beacon-chain.md#eth1data)


