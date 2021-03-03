#!/bin/bash

set -e
# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Creating wallet and adding user"

set -x

cd $DIR/../app/test

node add-to-wallet.js 