#!/usr/bin/env bash

rm -rf dockerConfig/crypto-config

mkdir -p dockerConfig/crypto-config

cp -r ../organizations/ordererOrganizations/ dockerConfig/crypto-config/
cp -r ../organizations/peerOrganizations/ dockerConfig/crypto-config/
sleep 5
docker-compose up -d
sleep 10
docker ps -a
