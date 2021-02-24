#!/bin/bash

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..

cd $DIR

if [ -z "$1" ]
  then
    CHAINCODE_VERSION=1.0
else
    CHAINCODE_VERSION="$1"
fi

CONFIG_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
ORG1_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/org1.energy-credit.com/users/Admin@org1.energy-credit.com/msp
PEER0_ORG1_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org1.energy-credit.com/peers/peer0.org1.energy-credit.com/tls/ca.crt
PEER1_ORG1_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org1.energy-credit.com/peers/peer1.org1.energy-credit.com/tls/ca.crt
PEER2_ORG1_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org1.energy-credit.com/peers/peer2.org1.energy-credit.com/tls/ca.crt
ORDERER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/ordererOrganizations/energy-credit.com/msp/tlscacerts/tlsca.energy-credit.com-cert.pem

CC_SRC_PATH=/opt/gopath/src/github.com/energy-credit/

set -x

echo "Removing devs containers and images"
docker stop $(docker ps -aqf "name=^dev-peer")
docker rm $(docker ps -aqf "name=^dev-peer") -v
sleep 5
docker image rm $(docker images | grep 'dev-peer')

echo "Installing smart contract on peer0.org1.energy-credit.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer0.org1.energy-credit.com:7051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n credit-contract \
    -v ${CHAINCODE_VERSION} \
    -p "$CC_SRC_PATH" \
    -l node

echo "Installing smart contract on peer1.org1.energy-credit.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer1.org1.energy-credit.com:8051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n credit-contract \
    -v ${CHAINCODE_VERSION} \
    -p "$CC_SRC_PATH" \
    -l node

echo "Installing smart contract on peer2.org1.energy-credit.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer1.org1.energy-credit.com:9051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n credit-contract \
    -v ${CHAINCODE_VERSION} \
    -p "$CC_SRC_PATH" \
    -l node

echo "Verify if smart contract was installed on peer0.org1.energy-credit.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_ADDRESS=peer0.org1.energy-credit.com:7051 \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode list --installed \
    -o orderer.energy-credit.com:7050 \
    -C credit \
    --tls \
    --cafile ${ORDERER_TLS_ROOTCERT_FILE}
