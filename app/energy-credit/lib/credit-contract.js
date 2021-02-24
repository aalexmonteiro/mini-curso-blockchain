'use strict';

/**
 * Smart contract for energy credit marketplace
 */

// Fabric smart contract classes
const { Contract, Context } = require('fabric-contract-api');
const Credit = require('./credit.js');
const CreditList = require('./credit-list.js');
const uuidv4 = require('uuid/v4');

/**
 * A custom context provides easy access to list of all credits marketplace
 */
class CreditMarketplaceContext extends Context {

    constructor() {
        super();
        this.creditList = new CreditList(this);
        this.paymentList = new PaymentList(this);
        this.walletList = new WalletList(this);
    }
}

/**
 * Define credit smart contract by extending Fabric Contract class
 *
 */
class CreditMarketplaceContract extends Contract {

    constructor() {
        // Unique name when multiple contracts per chaincode file
        super('energy-credit.com.creditmarketplace');
    }

    /**
     * Define a custom context for credit marketplace
    */
    createContext() {
        return new CreditMarketplaceContext();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be required.
     * @param {Context} ctx the transaction context
     */
    async instantiate(ctx) {
        // No implementation required with this example
        console.log('Instantiate the contract');
    }

    async creditRegistration(ctx, payload) {

        
    }

    async getCredit(ctx, payload) {
        
        
    }

    async updateCredit(ctx, payload) {

        
    }

}

module.exports = CreditMarketplaceContract;
