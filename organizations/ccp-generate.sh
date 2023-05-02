#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
         -e "s/\${ORG}/$6/" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG_NAME}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORG}/$6/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}
ORG1_NAME=$1
ORG2_NAME=$2
ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/${ORG1_NAME}/tlsca/tlsca.${ORG1_NAME}-cert.pem
CAPEM=organizations/peerOrganizations/${ORG1_NAME}/ca/ca.${ORG1_NAME}-cert.pem

echo "$(json_ccp $ORG1_NAME $P0PORT $CAPORT $PEERPEM $CAPEM $ORG)" > organizations/peerOrganizations/${ORG1_NAME}/connection-org1.json
echo "$(yaml_ccp $ORG1_NAME $P0PORT $CAPORT $PEERPEM $CAPEM $ORG)" > organizations/peerOrganizations/${ORG1_NAME}/connection-org1.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/${ORG2_NAME}/tlsca/tlsca.${ORG2_NAME}-cert.pem
CAPEM=organizations/peerOrganizations/${ORG2_NAME}/ca/ca.${ORG2_NAME}-cert.pem

echo "$(json_ccp $ORG2_NAME $P0PORT $CAPORT $PEERPEM $CAPEM $ORG)" > organizations/peerOrganizations/${ORG2_NAME}/connection-org2.json
echo "$(yaml_ccp $ORG2_NAME $P0PORT $CAPORT $PEERPEM $CAPEM $ORG)" > organizations/peerOrganizations/${ORG2_NAME}/connection-org2.yaml
