#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using Org1
ORG=${1:-Org1}

# Exit on first error, print all commands.
set -e
set -o pipefail

ORDERER_CA=${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/msp/tlscacerts/tlsca.udn.vn-cert.pem
PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/dut.udn.vn/peers/peer0.dut.udn.vn/tls/ca.crt
PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/sv.udn.vn/peers/peer0.sv.udn.vn/tls/ca.crt
FABRIC_CFG_PATH=${PWD}/config

if [[ ${ORG,,} == "org1" || ${ORG,,} == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=Org1MSP
   CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/dut.udn.vn/users/Admin@dut.udn.vn/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA

elif [[ ${ORG,,} == "org2" || ${ORG,,} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=Org2MSP
   CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/sv.udn.vn/users/Admin@sv.udn.vn/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA

else
   echo "Unknown \"$ORG\", please choose Org1/Digibank or Org2/Magnetocorp"
   echo "For example to get the environment variables to set upa Org2 shell environment run:  ./setOrgEnv.sh Org2"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Org2 | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_ORG1_CA=${PEER0_ORG1_CA}"
echo "PEER0_ORG2_CA=${PEER0_ORG2_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
