'use strict';

// Utility class for ledger state
const State = require('../ledger-api/state.js');

/**
 * Credit class extends State class
 * Class will be used by application and smart contract to define a credit
 */
class Credit extends State {

    constructor(obj) {
        super(Credit.getClass(), [obj.id]);
        Object.assign(this, obj);
    }

    setOwner(newOwner) {
        this.owner = newOwner;
    }

    static fromBuffer(buffer) {
        return Credit.deserialize(buffer);
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to credit object
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, Credit);
    }

    /**
     * Factory method to create a credit object
     */
    static createInstance(id, owner, credit) {
        return new Credit({ id, owner, credit });
    }

    static getClass() {
        return 'energy-credit.com.credit';
    }
}

module.exports = Credit;
