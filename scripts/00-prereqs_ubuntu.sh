#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Usage:
#
# ./prereqs-ubuntu.sh
#
# User must then logout and login upon completion of script
#

# Exit on any failure
set -e

# Array of supported versions
declare -a versions=('trusty' 'xenial' 'yakkety' 'Bionic');

# check the version and extract codename of ubuntu if release codename not provided by user
if [ -z "$1" ]; then
    source /etc/lsb-release || \
        (echo "Error: Release information not found, run script passing Ubuntu version codename as a parameter"; exit 1)
    CODENAME=${DISTRIB_CODENAME}
else
    CODENAME=${1}
fi

# check version is supported
if echo ${versions[@]} | grep -q -w ${CODENAME}; then
    echo "Installing Hyperledger Composer prereqs for Ubuntu ${CODENAME}"
else
    echo "Error: Ubuntu ${CODENAME} is not supported"
    exit 1
fi

# Update package lists
echo "# Updating package lists"
sudo apt-add-repository -y ppa:git-core/ppa
sudo apt-get update

# Install Git
echo "# Installing Git"
sudo apt-get install -y git

# Install nvm dependencies
echo "# Installing nvm dependencies"
sudo apt-get -y install build-essential libssl-dev

# Execute nvm installation script
echo "# Executing nvm installation script"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# Set up nvm environment without restarting the shell
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"

# Install node
echo "# Installing nodeJS"
nvm install --lts

# Configure nvm to use version 6.9.5
nvm use --lts
nvm alias default 'lts/*'

# Install the latest version of npm
echo "# Installing npm"
npm install npm@latest -g

# Install the npm version supported by Fabric
nvm install v8.11.3
nvm use 8.11.3

# Ensure that CA certificates are installed
sudo apt-get -y install apt-transport-https ca-certificates

# Update package lists
sudo apt-get update

# Install kernel packages which allows us to use aufs storage driver if V14 (trusty/utopic)
if [ "${CODENAME}" == "trusty" ]; then
    echo "# Installing required kernel packages"
    sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
fi

# Install python v2 if required
set +e
COUNT="$(python -V 2>&1 | grep -c 2.)"
if [ ${COUNT} -ne 1 ]
then
   sudo apt-get install -y python-minimal
fi

# Install unzip, required to install hyperledger fabric.
sudo apt-get -y install unzip

# Print installation details for user
echo ''
echo 'Installation completed, versions installed are:'
echo ''
echo -n 'Node:           '
node --version
echo -n 'npm:            '
npm --version
echo -n 'Docker:         '
docker --version
echo -n 'Docker Compose: '
docker-compose --version
echo -n 'Python:         '
python -V

# Print reminder of need to logout in order for these changes to take effect!
echo ''
echo "Please logout then login before continuing."

echo "Installing Composer tools"

npm install -g composer-cli@0.19.12
npm install -g generator-hyperledger-composer@0.19.12
npm install -g composer-rest-server@0.19.12
npm install -g yo
npm install -g composer-playground@0.19.12