#!/bin/sh

POA_SIGNER_ADDRESS=$(cat /gethdata/poa_signer.addr)

geth \
--maxpeers 25 --cache=2048 \
--rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 \
--rpcapi "db,eth,net,web3,personal" \
--port 30303 --rpcport 8545 \
--datadir /gethdata \
--unlock "$POA_SIGNER_ADDRESS" \
--etherbase "$POA_SIGNER_ADDRESS" \
--password /gethdata/poa_signer.pwd \
--mine