#!/bin/bash
# Exit on first error
set -e

echo "Downloading the Fabric Samples and utilities"
git clone -b master https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
git checkout v2.3.0
curl -sSL http://bit.ly/2ysbOFE | bash -s 2.3.0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Setting bin of utilities into PATH
# echo 'export PATH='$DIR'/bin:$PATH' >> ~/.profile

echo "Pulling the Hyperledger Images"

echo echo "Pulling the Fabric Peer"
docker pull hyperledger/fabric-peer:2.3.1
# docker tag hyperledger/fabric-peer:2.3.1 hyperledger/fabric-peer

echo echo "Pulling the Fabric Orderer"
docker pull hyperledger/fabric-orderer:2.3.1
# docker tag hyperledger/fabric-orderer:2.3.1 hyperledger/fabric-orderer

echo echo "Pulling the Fabric CCEnv"
docker pull hyperledger/fabric-ccenv:2.3.1
# docker tag hyperledger/fabric-ccenv:2.3.1 hyperledger/fabric-ccenv

echo echo "Pulling the Fabric CouchDB"
docker pull hyperledger/fabric-couchdb:0.4.22
# docker tag hyperledger/fabric-couchdb:0.4.22 hyperledger/fabric-couchdb

echo echo "Pulling the Fabric JavaEnv"
# docker pull hypserledger/fabric-javaenv:2.3.1
# docker tag hyperledger/fabric-javaenv:2.3.1 hyperledger/fabric-javaenv

echo echo "Pulling the Fabric CA"
docker pull hyperledger/fabric-ca:2.3.1
# docker tag hyperledger/fabric-ca:1.1.0 hyperledger/fabric-ca