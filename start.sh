#!/bin/bash
CHAIN_CODE_NAME=e-diploma
CHANNEL_NAME=e-channel
 export PATH=$PATH:$(realpath ../bin)
 export FABRIC_CFG_PATH=$(realpath ../config)
 export $(./setOrgEnv.sh Org1 | xargs)
./network.sh down
./network.sh up createChannel -c ${CHANNEL_NAME} -ca -s couchdb
./network.sh deployCC -ccn ${CHAIN_CODE_NAME} -ccp ./chaincode/e-diploma/chaincode-diploma -ccl java

# peer channel fetch newest e-channel.block -o localhost:7050 --ordererTLSHostnameOverride orderer.com -c e-channel --tls --cafile /home/khanh/VTS/vecert-network/organizations/ordererOrganizations/tlsca/tlsca.example.com-cert.pem
exec bash