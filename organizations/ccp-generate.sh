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
        -e "s/\${ORGNAME}/$6/" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGNAME}/$6/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
ORGNAME=issuer
P0PORT=7051
CAPORT=1054
PEERPEM=organizations/peerOrganizations/issuer.com/tlsca/tlsca.issuer.com-cert.pem
CAPEM=organizations/peerOrganizations/issuer.com/ca/ca.issuer.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGNAME)" > organizations/peerOrganizations/issuer.com/connection-org1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGNAME)" > organizations/peerOrganizations/issuer.com/connection-org1.yaml

ORG=2
ORGNAME=holder
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/holder.com/tlsca/tlsca.holder.com-cert.pem
CAPEM=organizations/peerOrganizations/holder.com/ca/ca.holder.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGNAME)" > organizations/peerOrganizations/holder.com/connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $ORGNAME)" > organizations/peerOrganizations/holder.com/connection-org2.yaml
