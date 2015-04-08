#!/usr/bin/env bash

export abi="/Users/marekkotewicz/ethereum/cpp-ethereum/build/abi/Debug/abi"
RPCPORT=8545
RED='\x1b[0;31m'
GREEN='\x1b[0;32m'
NO_COLOR='\x1b[0m'

if [[ ! -f "tmp/contracts.csv" ]];then 
    echo "You need to bootstrap contract before running test!"; exit 1
fi

CONTRACT_NAME=`cat tmp/contracts.csv | cut -d , -f 1`
CONTRACT_ADDRESS=`cat tmp/contracts.csv | cut -d , -f 2`
echo -e "tests for contract ${GREEN}${CONTRACT_NAME}${NO_COLOR} at address ${GREEN}${CONTRACT_ADDRESS}${NO_COLOR}"

EVENT=`awk "{if(NR%2!=0)print}" "tests/${CONTRACT_NAME}.tests"`
FUNCTION=`awk "{if(NR%2!=1)print}" "tests/${CONTRACT_NAME}.tests"`

echo -e "testing event with signature ${GREEN}${EVENT}${NO_COLOR} that should be triggered by function with signature ${GREEN}${FUNCTION}${NO_COLOR}"

echo "getting coinbase..."
COINBASE=`curl -s -X POST --data '{"jsonrpc": "2.0","method": "eth_coinbase", "params": [],"id": 1}' http://localhost:${RPCPORT} | grep result | cut -d : -f 2 | cut -d '"' -f 2`
echo -e "coinbase: ${GREEN}${COINBASE}${NO_COLOR}"

echo "calling contract function..."
TX="{\"jsonrpc\": \"2.0\",\"method\": \"eth_sendTransaction\", \"params\": [{\"from\": \"${COINBASE}\", \"data\": \"${FUNCTION}\", \"to\": \"${CONTRACT_ADDRESS}\"}],\"id\": 1}"
RESULT=`curl -s -X POST --data "${TX}" http://localhost:${RPCPORT} | grep result | cut -d : -f 2 | cut -d '"' -f 2`
echo -e "received result ${GREEN}${RESULT}${NO_COLOR}"

