#!/bin/bash

function setupOrg2CA() {

  echo "Setting org2 CA"

  mkdir -p organizations/peerOrganizations/holder.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/holder.com/
}

#here we are generating crypto material insted of cryptogen we are using CA
function createcertificatesForOrg2() {
  infoln "Enroll the CA admin"
  
  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:2054 --caname ca-holder --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null
}
#Orgnisation units will be useful in future
function nodeOrgnisationUnit() {
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier: 
    Certificate: cacerts/localhost-2054-ca-holder.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-holder.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-holder.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-holder.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/holder.com/msp/config.yaml"
}
function registerUsers() {
  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-holder --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-holder --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-holder --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-holder --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null
}

setupOrg2CA
createcertificatesForOrg2
sleep 2
nodeOrgnisationUnit
sleep 2
registerUsers
