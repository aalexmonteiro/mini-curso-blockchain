#!/bin/bash

set -e
# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Downloading the npm packages"

set -x

cd $DIR/../app/test

npm install 