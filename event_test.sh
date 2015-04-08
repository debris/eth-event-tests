#!/usr/bin/env bash

export solc="/Users/marekkotewicz/ethereum/cpp-ethereum/build/solc/Debug/solc"
RPCPORT=8545

echo "getting coinbase..."
COINBASE=`curl -s -X POST --data '{"jsonrpc": "2.0","method": "eth_coinbase", "params": [],"id": 1}' http://localhost:${RPCPORT} | grep result | cut -d : -f 2 | cut -d '"' -f 2`
echo "coinbase: ${COINBASE}"

echo "preparing tmp directory..."
rm -rf tmp && mkdir tmp && cd $_

echo "creating Test0 contract..."
echo 'contract Test0 {
    event Hello();

    function hello() {
        Hello();
    }
}' > Test0.sol


echo "creating binary and abi files..."
solc --input-file Test0.sol --json-abi file --binary file --add-std 0

TEST0_BINARY=`cat Test0.binary`
echo "test0 binary: ${TEST0_BINARY}"

TX="{\"jsonrpc\": \"2.0\",\"method\": \"eth_sendTransaction\", \"params\": [{\"from\": \"${COINBASE}\", \"data\": \"${TEST0_BINARY}\"}],\"id\": 1}"
echo "${TX}"
ADDRESS=`curl -s -X POST --data "${TX}" http://localhost:${RPCPORT} | grep result | cut -d : -f 2 | cut -d '"' -f 2`
echo "created contract at: ${ADDRESS}"

echo "Writing csv file!"
echo "Test0,${ADDRESS}" > contracts.csv
echo "Finished!"

