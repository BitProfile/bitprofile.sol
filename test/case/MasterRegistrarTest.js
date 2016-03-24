var BitProfile = require('bitprofile-contract');

var deploy = require('../util/contract/deploy');
var execute = require('../util/contract/execute');
var construct = require('../util/contract/construct');
var wait = require('../util/contract/wait');

function MasterRegistrarTest(web3)
{
    this.web3 = web3;
}


MasterRegistrarTest.prototype.initialize = function(){

    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var profileFactory = deploy(this.web3, BitProfile.ProfileFactory, []);
    var registrarFactory = deploy(this.web3, BitProfile.RegistrarFactory, [profileFactory.address]);
    this.master = deploy(this.web3, BitProfile.MasterRegistrar, [20, 1, registrarFactory.address]);
    this.start = this.web3.eth.blockNumber;
    return this.master!=false;
}


MasterRegistrarTest.prototype.createRegistrar = function(){

    if(!execute(this.web3, this.master.create, this.master, [])) return false;
    if(this.master.size.call()!=1) return false;
    var registrar = construct(this.web3, BitProfile.Registrar, this.master.get.call(0));
    if(!execute(this.web3, registrar.register, registrar, ["foo", ""])) return false;
    if(!registrar.contains.call("foo")) return false;
    return true;
}



MasterRegistrarTest.prototype.createBetaLimit = function(){
    if(!execute(this.web3, this.master.create, this.master, [])) return false;
    if(this.master.size.call()!=1) return false;
    return true;
}


MasterRegistrarTest.prototype.upgradeFactory = function(){
    var factory = deploy(this.web3, BitProfile.RegistrarFactory, []);
    if(!execute(this.web3, this.master.setFactory, this.master, [factory.address])) return false;
    var address = this.web3.eth.getStorageAt(this.master.address, 2);
    address = "0x"+address.substr(address.length - 40, address.length);
    if(factory.address!=address) return false;
    return true;
}

MasterRegistrarTest.prototype.upgradeRegistrar = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var factory = deploy(this.web3, BitProfile.ProfileFactory);
    var registrar = deploy(this.web3, BitProfile.Registrar, ["0x0000000000000000000000000000000000000000", factory.address, this.master.address]);
    if(!execute(this.web3, this.master.upgradeRegistrar, this.master, [0, registrar.address])) return false;
    if(this.master.get.call(0)!=registrar.address) return false;
    return true;
}

MasterRegistrarTest.prototype.upgrade = function(){
    var prev = this.master.get.call(0);
    var factory = deploy(this.web3, BitProfile.RegistrarFactory, []);
    if(!execute(this.web3, this.master.upgrade, this.master, [factory.address])) return false;
    if(this.master.get.call(0)==prev) return false;
    return true;
}

MasterRegistrarTest.prototype.createBetaExpired = function(){
    wait(this.web3, 20-(this.web3.eth.blockNumber-this.start));
    var curr = this.web3.eth.blockNumber;
    if(!execute(this.web3, this.master.create, this.master, [])) return false;
    if(this.master.size.call()!=2) return false;
    return true;
}

MasterRegistrarTest.prototype.upgradeRegistrarBetaExpired = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var factory = deploy(this.web3, BitProfile.ProfileFactory);
    var registrar = deploy(this.web3, BitProfile.Registrar, ["0x0000000000000000000000000000000000000000", factory.address, this.master.address]);
    if(!execute(this.web3, this.master.upgradeRegistrar, this.master, [0, registrar.address])) return false;
    if(this.master.get.call(0)==registrar.address) return false;
    return true;
}

MasterRegistrarTest.prototype.upgradeFactoryBetaExpired = function(){
    var factory = deploy(this.web3, BitProfile.RegistrarFactory, []);
    if(!execute(this.web3, this.master.setFactory, this.master, [factory.address])) return false;
    var address = this.web3.eth.getStorageAt(this.master.address, 2);
    address = "0x"+address.substr(address.length - 40, address.length);
    if(factory.address==address) return false;
    return true;
}

MasterRegistrarTest.prototype.upgradeBetaExpired = function(){
    var prev = this.master.get.call(0);
    var factory = deploy(this.web3, BitProfile.RegistrarFactory, []);
    if(!execute(this.web3, this.master.upgrade, this.master, [factory.address])) return false;
    if(this.master.get.call(0)!=prev) return false;
    return true;
}

module.exports = MasterRegistrarTest;
