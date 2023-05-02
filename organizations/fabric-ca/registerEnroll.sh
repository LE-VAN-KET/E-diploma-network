#!/bin/bash
. common/common.sh
function createOrg1() {
  . organizations/fabric-ca/org1/enrollOrg1AdminAndUsers.sh
  . organizations/fabric-ca/org1/generateMSPOrg1.sh
}

function createOrg2() {
  . organizations/fabric-ca/org2/enrollOrg2AdminAndUsers.sh
  . organizations/fabric-ca/org2/generateMSPOrg2.sh
}

function createOrderer() {
  . orderer/enrollAdminAndMSP.sh
}
