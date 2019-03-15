# Messages

## `0x00` Hello

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

## `0x10` Request block root

```python
{
  'start_root': 'bytes32'
  'start_slot': 'uint64'
  'max': 'uint64'
  'skip': 'uint64'
  'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
}
```

## `0x11` Send block root

[{block_root: bytes32, slot: uint64}, …]

## `0x12` Request block header

```python
{
  'start_root': 'bytes32'
  'start_slot': 'uint64'
  'max': 'uint64'
  'skip': 'uint64'
  'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
}
```

## `0x13` Send block header
? Block header structure ?

## `0x14` Request block body

```python
{
  'start_root': 'bytes32'
  'start_slot': 'uint64'
  'max': 'uint64'
  'skip': 'uint64'
  'direction': 'uint8' # 0x01 is forward, 0x00 is backwards
}
```

## `0x15` Send block body
? Block body structure ?
