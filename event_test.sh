#!/usr/bin/env bash

export solc="/Users/marekkotewicz/ethereum/cpp-ethereum/build/solc/Debug/solc"
RPCPORT=8545

rm -rf tmp && mkdir tmp && cd $_

echo 'contract Test0 {
    event Hello();

    function hello() {
        Hello();
    }
}' > Test0.sol

solc --input-file Test0.sol --json-abi file --binary file --add-std 0

echo ${code1}

