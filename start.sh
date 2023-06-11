#!/bin/sh
CHAIN_CODE_NAME=e-diploma
CHANNEL_NAME=mychannel
 export PATH=$PATH:$(realpath ../bin)
 export FABRIC_CFG_PATH=$(realpath ../config)
 export $(./setOrgEnv.sh Org2 | xargs)
./network.sh down
./network.sh up createChannel -c ${CHANNEL_NAME} -ca -s couchdb
./network.sh deployCC -ccn ${CHAIN_CODE_NAME} -ccp ./chaincode/e-diploma -ccl java

# peer channel fetch newest mychannel.block -o localhost:7050 --ordererTLSHostnameOverride orderer.com -c mychannel --tls --cafile /home/khanh/VTS/vecert-network/organizations/ordererOrganizations/tlsca/tlsca.example.com-cert.pem
