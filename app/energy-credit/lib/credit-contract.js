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
        let uuid = uuidv4();
        let obj = JSON.parse(payload);
        console.log(obj);
        let credit = Credit.createInstance(uuid, payload.owner, payload.credit);

        await ctx.creditList.add(credit);

        return credit;
        
    }

    async getCredit(ctx, payload) {
        let obj = JSON.parse(payload);
        let credit = await ctx.creditList.get(obj.id);
        
        return credit;
    }

    async getbyOwner(ctx, payload) {
        let obj = JSON.parse(payload);
        let res = await ctx.creditList.getByOwner(obj.owner);
        let credit = Credit.fromBuffer(res[0]);

        return credit;
    }
}

module.exports = CreditMarketplaceContract;
