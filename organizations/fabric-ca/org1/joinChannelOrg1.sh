#!/bin/bash

CHANNEL_NAME=mychannel
DELAY="$2"
TIMEOUT="$3"
VERBOSE="$4"
COUNTER=1
MAX_RETRY=5

. scripts/envVar.sh

export CORE_PEER_TLS_ENABLED=true
export PATH=${PWD}/bin:$PATH
# export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
# export ORDERER_CERT=${PWD}/organizations/ordererOrganizations/example.com/msp/cacerts/localhost-9054-ca-orderer.pem
# export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/issuer.com/tlsca/tlsca.issuer.com-cert.pem
export FABRIC_CFG_PATH=${PWD}/config

setGlobalsForPeer0Org1() {
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/issuer.com/users/Admin@issuer.com/msp
  export CORE_PEER_ADDRESS=localhost:7051

}

setGlobalsForPeer1Org1() {
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/issuer.com/users/Admin@issuer.com/msp
  export CORE_PEER_ADDRESS=localhost:7058

}

fetchChannelBlock() {
  setGlobals 1

  infoln "Fetching the most recent configuration block for the channel"
  set -x
  peer channel fetch config config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.com -c mychannel --tls --cafile "$ORDERER_CA"
  res=$?
  { set +x; } 2>/dev/null
  
}


joinChannel() {
  # setGlobalsForPeer0Org1
  # peer channel join -b $CHANNEL_NAME.block

  setGlobalsForPeer1Org1
  peer channel join -b $CHANNEL_NAME.block
}

updateAnchorPeers() {
  setGlobalsForPeer0Org1
  peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.com -c $CHANNEL_NAME -f ./${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

fetchChannelBlock
# joinChannel
# updateAnchorPeers



