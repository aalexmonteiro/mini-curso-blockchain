'use strict';

//IMPORTANT: TO DO: This is a PoC and is necessary to improve the way that to get the credentials
// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const { FileSystemWallet, X509WalletMixin } = require('fabric-network');
const path = require('path');

const fixtures = path.resolve(__dirname, '../../../mini-curso-blockchain');

// A wallet stores a collection of identities
const wallet = new FileSystemWallet(path.join(fixtures, '/identity/user/wallet').toString());

async function main() {

    try {

        const identityLabel = 'User1@org1.energy-credit.com';

        // Identity to credentials to be stored in the wallet
        const credPath = path.join(fixtures, '/crypto-config/peerOrganizations/org1.energy-credit.com/users', identityLabel);
        const cert = fs.readFileSync(path.join(credPath, '/msp/signcerts/User1@org1.energy-credit.com-cert.pem')).toString();
        const keyName = fs.readdirSync(path.join(credPath, '/msp/keystore'));
        console.log(keyName.toString())
        const key = fs.readFileSync(path.join(credPath, '/msp/keystore', keyName.toString())).toString();
        
        // Load credentials into wallet
        const identity = X509WalletMixin.createIdentity('Org1MSP', cert, key);

        await wallet.import(identityLabel, identity);

    } catch (error) {
        console.log(`Error adding to wallet. ${error}`);
        console.log(error.stack);
    }
}

main().then(() => {
    console.log('done');
}).catch((e) => {
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
});