#!/bin/bash

function setupOrg1CA() {

  echo "Setting Org1 CA"

  mkdir -p organizations/peerOrganizations/issuer.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/issuer.com/
}

#here we are generating crypto material insted of cryptogen we are using CA
function createcertificatesForOrg1() {
  infoln "Enroll the CA admin"
  
  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1054 --caname ca-issuer --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null
}
#Orgnisation units will be useful in future
function nodeOrgnisationUnit() {
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier: 
    Certificate: cacerts/localhost-1054-ca-issuer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1054-ca-issuer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1054-ca-issuer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1054-ca-issuer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/issuer.com/msp/config.yaml"
}
function registerUsers() {
  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-issuer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-issuer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-issuer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-issuer --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null
}

setupOrg1CA
createcertificatesForOrg1
sleep 2
nodeOrgnisationUnit
sleep 2
registerUsers
