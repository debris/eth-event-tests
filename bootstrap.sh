#!/usr/bin/env bash

#export solc="/Users/marekkotewicz/ethereum/cpp-ethereum/build/solc/Debug/solc"
RPCPORT=8545
RED='\x1b[0;31m'
GREEN='\x1b[0;32m'
NO_COLOR='\x1b[0m'

function help()
{
    echo "./bootstrap.sh <file> <contract_name>"
}

if [[ ${1} == "--help" ]]; then
    help; exit 0
fi

function require_solc ()
{
    command -v solc >/dev/null 2>&1 || { echo -e "${RED}solc is required, but it's not installed. Aborting." >&2; exit 1; }
}

require_solc

if [ ! ${1} ];then 
    echo "you have to specify test contract location!"; help; exit 1
fi

if [ ! ${2} ];then
    echo "you have to specify test contract name!"; help; exit 1
fi

LOCATION=${1}
NAME=${2}

echo "getting coinbase..."
COINBASE=`curl -s -X POST --data '{"jsonrpc": "2.0","method": "eth_coinbase", "params": [],"id": 1}' http://localhost:${RPCPORT} | grep result | cut -d : -f 2 | cut -d '"' -f 2`
COINBASE=${COINBASE:-"${RED}ERROR, check if you have started go with jsonrpc on port ${RPCPORT}"}
echo -e "coinbase: ${GREEN}${COINBASE}${NO_COLOR}"

echo "preparing tmp directory..."
rm -rf tmp && mkdir tmp

echo "loading test contract: ${LOCATION}"
cat ${LOCATION} > "tmp/contract.sol"

echo "entering tmp directory..."
cd tmp

echo "creating binary and abi files..."
solc --input-file contract.sol --json-abi file --binary file --add-std 0

CONTRACT_BINARY=`cat ${NAME}.binary`
echo "test0 binary: ${CONTRACT_BINARY}"

TX="{\"jsonrpc\": \"2.0\",\"method\": \"eth_sendTransaction\", \"params\": [{\"from\": \"${COINBASE}\", \"data\": \"${CONTRACT_BINARY}\"}],\"id\": 1}"
echo "${TX}"
ADDRESS=`curl -s -X POST --data "${TX}" http://localhost:${RPCPORT} | grep result | cut -d : -f 2 | cut -d '"' -f 2`
ADDRESS=${ADDRESS:-"${RED}ERROR, check if you have unlocked your account"}
echo -e "created contract at: ${GREEN}${ADDRESS}${NO_COLOR}"

echo "Writing csv file!"
echo "Test0,${ADDRESS}" > contracts.csv
echo "Finished!"
echo -e "${RED}Now you should mine transactions!${NO_COLOR}"

