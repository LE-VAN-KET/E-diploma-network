#!/bin/bash

function createMSPPeer0() {
  # Copy org2's CA cert to org2's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/holder.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/holder.com/msp/tlscacerts/ca.crt"

  # Copy org2's CA cert to org2's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/holder.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/holder.com/tlsca/tlsca.holder.com-cert.pem"

  # Copy org2's CA cert to org2's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/holder.com/ca"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/holder.com/ca/ca.holder.com-cert.pem"

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:2054 --caname ca-holder -M "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/msp" --csr.hosts peer0.holder.com --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/holder.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:2054 --caname ca-holder -M "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/tls" --enrollment.profile tls --csr.hosts peer0.holder.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/holder.com/peers/peer0.holder.com/tls/server.key"
}

function createMSPPeer1() {
  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:2054 --caname ca-holder -M "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/msp" --csr.hosts peer1.holder.com --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null
  
  cp "${PWD}/organizations/peerOrganizations/holder.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/msp/config.yaml"


  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:2054 --caname ca-holder -M "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/tls" --enrollment.profile tls --csr.hosts peer1.holder.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/holder.com/peers/peer1.holder.com/tls/server.key"

}
function generateUserMSP() {
  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:2054 --caname ca-holder -M "${PWD}/organizations/peerOrganizations/holder.com/users/User1@holder.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/holder.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/holder.com/users/User1@holder.com/msp/config.yaml"

}
function generateAdminMSP() {
  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:2054 --caname ca-holder -M "${PWD}/organizations/peerOrganizations/holder.com/users/Admin@holder.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/holder.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/holder.com/users/Admin@holder.com/msp/config.yaml"
}

createMSPPeer0
createMSPPeer1
generateUserMSP
generateAdminMSP

  


