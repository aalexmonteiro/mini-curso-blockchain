#!/bin/bash

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..

if [ -z "$1" ]
  then
    CHAINCODE_VERSION=1.0
else
    CHAINCODE_VERSION="$1"
fi

cd $DIR

CONFIG_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
ORG1_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/org1.energy-credit.com/users/Admin@org1.energy-credit.com/msp
ORG1_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org1.energy-credit.com/peers/peer0.org1.energy-credit.com/tls/ca.crt
ORDERER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/ordererOrganizations/energy-credit.com/msp/tlscacerts/tlsca.energy-credit.com-cert.pem
set -x

echo "Instantiating smart contract on credit channel"

docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_ADDRESS=peer0.org1.energy-credit.com:7051 \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode instantiate \
    -o orderer.energy-credit.com:7050 \
    -C credit \
    -n credit-contract \
    -l node \
    -v $CHAINCODE_VERSION \
    -c '{"Args":[]}' \
    -P "AND('Org1MSP.member')" \
    --tls \
    --cafile ${ORDERER_TLS_ROOTCERT_FILE}