#!/bin/bash

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..

cd $DIR
set -x
docker-compose -f docker-compose-peers.yaml up  -d

echo "Peers started successfully"

echo "Starting fabric-ca docker image"
set -x
export FABRIC_CA_SERVER_ORG1_CA_KEYFILE=$(cd ./crypto-config/peerOrganizations/org1.energy-credit.com/ca  && ls *_sk)
source ~/.profile
source ~/.bashrc
set -x
docker-compose -f docker-compose-ca.yaml up -d

echo "CA started successfully"