var BitProfile = require('bitprofile-contract');

var deploy = require('../util/contract/deploy');
var execute = require('../util/contract/execute');

function AddressAuthTest(web3)
{
    this.web3 = web3;
}


AddressAuthTest.prototype.initialize = function(){

    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    this.auth = deploy(this.web3, BitProfile.AddressAuth, [this.web3.eth.defaultAccount]);
    return this.auth!=false;
}


AddressAuthTest.prototype.testAuth = function(){
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 1)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 2)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 3)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[0], "", 4)) return false; //no such permission
    return true;
}


AddressAuthTest.prototype.testAuthFailed = function(){
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 1)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 2)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 3)) return false;
    return true;
}


AddressAuthTest.prototype.testAddPermission = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    if(!execute(this.web3, this.auth.set, this.auth, [this.web3.eth.accounts[1], 1])) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[1], "", 1)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 2)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 3)) return false;
    return true;
}

AddressAuthTest.prototype.testAddPermissionError  = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    execute(this.web3, this.auth.set, this.auth, [this.web3.eth.accounts[0], 1])
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 1)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 2)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 3)) return false;
    return true;
}

AddressAuthTest.prototype.testRemovePermission = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    if(!execute(this.web3, this.auth.remove, this.auth, [this.web3.eth.accounts[1]])) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 1)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 2)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 3)) return false;
    return true;
}

AddressAuthTest.prototype.testRemovePermissionError = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    execute(this.web3, this.auth.remove, this.auth, [this.web3.eth.accounts[0]]);
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 1)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 2)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 3)) return false;
    return true;
}

AddressAuthTest.prototype.testNotEnoughPrivileges = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    if(!execute(this.web3, this.auth.set, this.auth, [this.web3.eth.accounts[1], 2])) return false;
    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    if(!this.auth.authenticate.call(this.web3.eth.accounts[1], "", 1)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[1], "", 2)) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 3)) return false;
    if(!execute(this.web3, this.auth.set, this.auth, [this.web3.eth.accounts[1], 3])) return false;
    if(this.auth.authenticate.call(this.web3.eth.accounts[1], "", 3)) return false;
    return true;
}

AddressAuthTest.prototype.removeOwnAddress = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    if(!execute(this.web3, this.auth.remove, this.auth, [this.web3.eth.accounts[0]])) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 1)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 2)) return false;
    if(!this.auth.authenticate.call(this.web3.eth.accounts[0], "", 3)) return false;
    return true;
}

module.exports = AddressAuthTest;
