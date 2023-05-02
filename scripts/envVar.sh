#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

#export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/msp/tlscacerts/tlsca.udn.vn-cert.pem
#export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
#export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
#export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem
#export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/server.crt
#export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    if [ $# -ne 3 ]; then
      infoln "SetGlobals method must to 3 args..."
    fi
    USING_ORG=$1
    ORG_NAME=$2
    PEER_NO=$3
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/${ORG_NAME}/tlsca/tlsca.${ORG_NAME}-cert.pem
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/${ORG_NAME}/users/Admin@${ORG_NAME}/msp
    if [ $PEER_NO -eq 0 ]; then
      export CORE_PEER_ADDRESS=localhost:7051
    else
      export CORE_PEER_ADDRESS=localhost:8051
    fi

  elif [ $USING_ORG -eq 2 ]; then
    export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/${ORG_NAME}/tlsca/tlsca.${ORG_NAME}-cert.pem
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/${ORG_NAME}/users/Admin@${ORG_NAME}/msp
    if [ $PEER_NO -eq 0 ]; then
      export CORE_PEER_ADDRESS=localhost:9051
    else
      export CORE_PEER_ADDRESS=localhost:10051
    fi

  elif [ $USING_ORG -eq 3 ]; then
    export $PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/${ORG_NAME}/tlsca/tlsca.${ORG_NAME}-cert.pem
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/${ORG_NAME}/users/Admin@${ORG_NAME}/msp
    export CORE_PEER_ADDRESS=localhost:11051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  ORG_NAME=$2
  setGlobals $1 $ORG_NAME 0

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.${ORG_NAME}:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.${ORG_NAME}:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.${ORG_NAME}:11051
  else
    errorln "ORG Unknown"
  fi
}

. common/common.sh

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation

parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    if [ $1 -eq 1 ]; then
      setGlobals $1 $ORG1_NAME 0
    elif [ $1 -eq 2 ]; then
      setGlobals $1 $ORG2_NAME 0
    fi
    PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_ORG$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
