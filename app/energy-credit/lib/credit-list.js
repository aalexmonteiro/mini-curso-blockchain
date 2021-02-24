'use strict';

// Utility class for collections of ledger states -- a state list
const StateList = require('../ledger-api/statelist.js');

const Credit = require('./credit.js');

class CreditList extends StateList {

    constructor(ctx) {
        super(ctx, 'energy-credit.com.creditlist');
        this.use(Credit);
    }

    async add(credit) {
        return this.addState(credit);
    }

    async get(key) {
        return this.getState(key);
    }

    async getById(id) {
        let queryString = {};
        queryString.selector = {};
        queryString.selector.id = id;
        return this.getQueryResult(JSON.stringify(queryString));
    }

    async update(credit) {
        return this.updateState(credit);
    }

    async delete(key) {
        return this.deleteState(key);
    }
}


module.exports = CreditList;