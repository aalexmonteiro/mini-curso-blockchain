#!/bin/bash

echo "create channel 'credit'"
set -x	
docker exec -it \
-e ORDERER_ADDRESS="orderer.energy-credit.com:7050" \
-e ORDERER_CA="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/energy-credit.com/orderers/orderer.energy-credit.com/msp/tlscacerts/tlsca.energy-credit.com-cert.pem" \
-e CHANNEL_NAME="credit" \
cli sh -c 'peer channel create -o $ORDERER_ADDRESS -c $CHANNEL_NAME -f ./channel-artifacts/$CHANNEL_NAME/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA'

echo "'peer0.org1.energy-credit.com' join channel 'credit'"
set -x
docker exec -it \
-e CORE_PEER_ADDRESS="peer0.org1.energy-credit.com:7051" \
-e CORE_PEER_LOCALMSPID="Org1MSP" \
-e CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/users/Admin@org1.energy-credit.com/msp" \
-e CORE_PEER_TLS_CERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer0.org1.energy-credit.com/tls/server.crt" \
-e CORE_PEER_TLS_KEY_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer0.org1.energy-credit.com/tls/server.key" \
-e CORE_PEER_TLS_ROOTCERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer0.org1.energy-credit.com/tls/ca.crt" \
-e CHANNEL_NAME="credit" \
cli sh -c 'peer channel join -b $CHANNEL_NAME.block'

echo "'peer1.org1.energy-credit.com' join channel 'credit'"
set -x
docker exec -it \
-e CORE_PEER_ADDRESS="peer1.org1.energy-credit.com:8051" \
-e CORE_PEER_LOCALMSPID="Org1MSP" \
-e CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/users/Admin@org1.energy-credit.com/msp" \
-e CORE_PEER_TLS_CERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer1.org1.energy-credit.com/tls/server.crt" \
-e CORE_PEER_TLS_KEY_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer1.org1.energy-credit.com/tls/server.key" \
-e CORE_PEER_TLS_ROOTCERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer1.org1.energy-credit.com/tls/ca.crt" \
-e CHANNEL_NAME="credit" \
cli sh -c 'peer channel join -b $CHANNEL_NAME.block'

echo "'peer2.org1.energy-credit.com' join channel 'credit'"
set -x
docker exec -it \
-e CORE_PEER_ADDRESS="peer2.org1.energy-credit.com:9051" \
-e CORE_PEER_LOCALMSPID="Org1MSP" \
-e CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/users/Admin@org1.energy-credit.com/msp" \
-e CORE_PEER_TLS_CERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer2.org1.energy-credit.com/tls/server.crt" \
-e CORE_PEER_TLS_KEY_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer2.org1.energy-credit.com/tls/server.key" \
-e CORE_PEER_TLS_ROOTCERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.energy-credit.com/peers/peer2.org1.energy-credit.com/tls/ca.crt" \
-e CHANNEL_NAME="credit" \
cli sh -c 'peer channel join -b $CHANNEL_NAME.block'