#!/bin/bash

function createMSPPeer0() {
  # Copy org1's CA cert to org1's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/issuer.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/issuer.com/msp/tlscacerts/ca.crt"

  # Copy org1's CA cert to org1's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/issuer.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/issuer.com/tlsca/tlsca.issuer.com-cert.pem"

  # Copy org1's CA cert to org1's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/issuer.com/ca"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/issuer.com/ca/ca.issuer.com-cert.pem"

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1054 --caname ca-issuer -M "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/msp" --csr.hosts peer0.issuer.com --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/issuer.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1054 --caname ca-issuer -M "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/tls" --enrollment.profile tls --csr.hosts peer0.issuer.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer0.issuer.com/tls/server.key"
}

function createMSPPeer1() {
  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1054 --caname ca-issuer -M "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/msp" --csr.hosts peer1.issuer.com --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null
  
  cp "${PWD}/organizations/peerOrganizations/issuer.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/msp/config.yaml"


  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1054 --caname ca-issuer -M "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/tls" --enrollment.profile tls --csr.hosts peer1.issuer.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/issuer.com/peers/peer1.issuer.com/tls/server.key"

}
function generateUserMSP() {
  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1054 --caname ca-issuer -M "${PWD}/organizations/peerOrganizations/issuer.com/users/User1@issuer.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/issuer.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/issuer.com/users/User1@issuer.com/msp/config.yaml"

}
function generateAdminMSP() {
  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:1054 --caname ca-issuer -M "${PWD}/organizations/peerOrganizations/issuer.com/users/Admin@issuer.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/issuer.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/issuer.com/users/Admin@issuer.com/msp/config.yaml"
}

createMSPPeer0
createMSPPeer1
generateUserMSP
generateAdminMSP

  


