#!/bin/bash
set -e
# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..

which cryptogen
if [ "$?" -ne 0 ]; then
  echo "cryptogen tool not found. exiting"
  exit 1
fi

which configtxgen
if [ "$?" -ne 0 ]; then
  echo "configtxgen tool not found. exiting"
  exit 1
fi

echo "Remove previous channels artifacts"

rm -fr $DIR/channel-artifacts/*
rm -fr $DIR/crypto-config/*

# Hackaton
mkdir -p $DIR/channel-artifacts/credit

cd $DIR

echo "Generate certificates using cryptogen tool"
set -x
cryptogen generate --config=$DIR/crypto-config.yaml --output=$DIR/crypto-config
if [ "$?" -ne 0 ]; then
  echo "Failed to generate certificates..."
  exit 1
fi

CHANNEL_NAME="credit"
echo "Generating Orderer Genesis block"
set -x
configtxgen -profile OneOrgsOrdererGenesis -channelID "orderer-credit-channel" -outputBlock $DIR/channel-artifacts/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# channel name must be lower case, can contain numbers, can not contain '_', 
echo "Generating 'credit' channel configuration transaction 'channel.tx'"
set -x
configtxgen -profile OneOrgsChannel -outputCreateChannelTx $DIR/channel-artifacts/credit/channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate 'credit' channel configuration transaction..."
  exit 1
fi

echo "Generating anchor peer update for Org1MSP"
set -x
configtxgen -profile OneOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
res=$?
set +x
if [ $res -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi