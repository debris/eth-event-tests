# eth-event-tests

eth-event-test can be used to bootstrap contracts to ethereum network and check the events they log

### requirements:
- go-ethereum
- solc (on of the cpp-ethereum executables)
- bash (with cl tools: curl, grep, cut, awk)

### usage:
- put solc in your path (or export it: `export solc=/your_path_to_solc/solc`)
- start go-ethereum with jsonrpc server on port 8545, some money in coinbase and unlocked account

### boostrap contract

```bash
# ./bootstrap.sh <file> <contract_name>
./bootstrap.sh tests/Test0.sol Test0
```

### get events from contract

```
./test.sh
```

### play with it

```
you can modify test.sh to check various return values from `eth_getLogs`
```

