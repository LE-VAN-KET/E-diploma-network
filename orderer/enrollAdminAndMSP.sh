#!/bin/bash

setupOrdererCA() {

  echo "Setting Orderer CA"
  mkdir -p organizations/ordererOrganizations/udn.vn
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/udn.vn
}
enrollCAAdmin() {
  echo "Enroll the CA admin"

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null
  sleep 2
}
nodeOrgnisationUnit() {
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/udn.vn/msp/config.yaml
  sleep 2
}
registerUsers() {
  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  echo
  echo "Register orderer2"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  echo
  echo "Register orderer3"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  mkdir -p organizations/ordererOrganizations/udn.vn/orderers

}
orderer1MSP() {

  mkdir -p organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer \
    -M ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/msp \
    --csr.hosts orderer.udn.vn --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2

  cp ${PWD}/organizations/ordererOrganizations/udn.vn/msp/config.yaml ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer \
    -M ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls \
    --enrollment.profile tls --csr.hosts orderer.udn.vn --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2

  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/keystore/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/msp/tlscacerts/tlsca.udn.vn-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/udn.vn/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/msp/tlscacerts/tlsca.udn.vn-cert.pem

}
orderer2MSP() {
  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer \
    -M ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/msp \
    --csr.hosts orderer2.udn.vn --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  cp ${PWD}/organizations/ordererOrganizations/udn.vn/msp/config.yaml ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer \
    -M ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls \
    --enrollment.profile tls --csr.hosts orderer2.udn.vn --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/keystore/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/msp/tlscacerts/tlsca.udn.vn-cert.pem

  # mkdir ${PWD}/organizations/ordererOrganizations/udn.vn/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer2.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/msp/tlscacerts/tlsca.udn.vn-cert.pem

}
orderer3MSP() {
  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer \
    -M ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/msp \
    --csr.hosts orderer3.udn.vn --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/msp/config.yaml ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer \
    -M ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls \
    --enrollment.profile tls --csr.hosts orderer3.udn.vn --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls/keystore/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/udn.vn/orderers/orderer3.udn.vn/msp/tlscacerts/tlsca.udn.vn-cert.pem

}
adminMSP() {
  mkdir -p organizations/ordererOrganizations/udn.vn/users
  mkdir -p organizations/ordererOrganizations/udn.vn/users/Admin@udn.vn

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer \
    -M ${PWD}/organizations/ordererOrganizations/udn.vn/users/Admin@udn.vn/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/organizations/ordererOrganizations/udn.vn/msp/config.yaml ${PWD}/organizations/ordererOrganizations/udn.vn/users/Admin@udn.vn/msp/config.yaml

}
setupOrdererCA
enrollCAAdmin
nodeOrgnisationUnit
registerUsers
orderer1MSP
orderer2MSP
orderer3MSP
adminMSP
