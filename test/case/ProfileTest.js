var BitProfile = require('bitprofile-contract');

var deploy = require('../util/contract/deploy');
var execute = require('../util/contract/execute');

function ProfileTest(web3)
{
    this.web3 = web3;
}


ProfileTest.prototype.initialize = function(){

    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var auth = deploy(this.web3, BitProfile.AddressAuth, [this.web3.eth.defaultAccount]);
    this.profile = deploy(this.web3, BitProfile.Profile, [auth.address]);
    return this.profile!=false;
}


ProfileTest.prototype.testAuth = function(){
    if(!this.profile.authenticate.call(1)) return false;
    if(!this.profile.authenticate.call(2)) return false;
    if(!this.profile.authenticate.call(3)) return false;
    if(this.profile.authenticate.call(4)) return false; //no such permission
    return true;
}


ProfileTest.prototype.testAuthFailed = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    if(this.profile.authenticate.call(1)) return false;
    if(this.profile.authenticate.call(2)) return false;
    if(this.profile.authenticate.call(3)) return false;
    return true;
}


ProfileTest.prototype.testEdit = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    if(!execute(this.web3, this.profile.set, this.profile, ["foo", "bar"])) return false;
    return this.profile.get.call("foo") == "bar";
}


ProfileTest.prototype.testEditError = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    if(!execute(this.web3, this.profile.set, this.profile, ["bar", "foo"])) return false;
    return !this.profile.get.call("bar");
}


ProfileTest.prototype.testTransfer = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var auth = deploy(this.web3, BitProfile.AddressAuth, [this.web3.eth.accounts[1]]);
    if(!execute(this.web3, this.profile.transfer, this.profile, [auth.address])) return false;

    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    if(!this.profile.authenticate.call(1)) return false;
    if(!this.profile.authenticate.call(2)) return false;
    if(!this.profile.authenticate.call(3)) return false;

    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    if(this.profile.authenticate.call(1)) return false;
    if(this.profile.authenticate.call(2)) return false;
    if(this.profile.authenticate.call(3)) return false;
    return true;
}


ProfileTest.prototype.testTransferError = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var auth = deploy(this.web3, BitProfile.AddressAuth, [this.web3.eth.accounts[0]]);
    if(!execute(this.web3, this.profile.transfer, this.profile, [auth.address])) return false;

    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    if(!this.profile.authenticate.call(1)) return false;
    if(!this.profile.authenticate.call(2)) return false;
    if(!this.profile.authenticate.call(3)) return false;

    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    if(this.profile.authenticate.call(1)) return false;
    if(this.profile.authenticate.call(2)) return false;
    if(this.profile.authenticate.call(3)) return false;
    return true;
}


module.exports = ProfileTest;
