#!bin/bash
CHAIN_CODE_NAME=e-diploma
./network.sh up createChannel -c diplomachannel -ca -s couchdb
export $(./setOrgEnv.sh Org1 | xargs)
./network.sh deployCC -ccn ${CHAIN_CODE_NAME} -ccp ./chaincode/e-diploma -ccl java
