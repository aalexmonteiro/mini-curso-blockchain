

'use strict';

//IMPORTANT: TO DO: This is a PoC and is necessary to improve the way that to get the credentials
// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { FileSystemWallet, Gateway } = require('fabric-network');
const Credit = require('../energy-credit/lib/credit.js');

// A wallet stores a collection of identities for use
const wallet = new FileSystemWallet('../../identity/user/wallet');

// Main program function
async function main() {

    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    // Main try/catch block
    try {

        // Specify userName for network access
        const userName = 'User1@org1.energy-credit.com';
        const channel = 'credit'

        // Load connection profile; will be used to locate a gateway
        let connectionProfile = yaml.safeLoad(fs.readFileSync('../../gateway/networkConnection.yaml', 'utf8'));

        // Set connection options; identity and wallet
        let connectionOptions = {
            identity: userName,
            wallet: wallet,
            discovery: { enabled: true, asLocalhost: true }
        };

        // Connect to gateway using application specified parameters
        console.log('Connect to Fabric gateway.');

        await gateway.connect(connectionProfile, connectionOptions);

        console.log('Use network channel: ' + channel);

        const network = await gateway.getNetwork(channel);

        const contract = await network.getContract('credit-contract');

        console.log('Submit a query transaction.');

        // let jsonPayload = {
        //     id: '9b1320bb-95ba-4c1a-8bd8-12527b3d0910'
        // }

        let jsonPayload = {
            owner: 'Chico'
        }

        const registerResponse = await contract.submitTransaction('getbyOwner', JSON.stringify(jsonPayload));

        let credit = Credit.fromBuffer(registerResponse);

        console.log(`Credit Owner:${credit.owner}, Credits: ${credit.credit}, Id: ${credit.id}`);
        console.log('Transaction complete.');
    } catch (error) {

        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);

    } finally {

        // Disconnect from the gateway
        console.log('Disconnect from Fabric gateway.');
        gateway.disconnect();

    }
}
main().then(() => {

    console.log('Issue program complete.');

}).catch((e) => {

    console.log('Issue program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);

});