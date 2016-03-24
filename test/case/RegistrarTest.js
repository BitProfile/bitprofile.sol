var BitProfile = require('bitprofile-contract');

var deploy = require('../util/contract/deploy');
var execute = require('../util/contract/execute');
var construct = require('../util/contract/construct');

function RegistrarTest(web3)
{
    this.web3 = web3;
}


RegistrarTest.prototype.initialize = function(){

    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var context = deploy(this.web3, BitProfile.RegistrarContext);
    this.factory = deploy(this.web3, BitProfile.ProfileFactory);
    this.registrar = deploy(this.web3, BitProfile.Registrar, [context.address, this.factory.address, this.web3.eth.defaultAccount]);
    if(!execute(this.web3, context.transfer, context, [this.registrar.address])) return false;
    return this.registrar!=false;
}


RegistrarTest.prototype.createProfile = function()
{
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];

    if(!execute(this.web3, this.registrar.register, this.registrar, ["foo", ""])) return false;
    if(!this.registrar.contains.call("foo")) return false;

    var info = this.registrar.get.call("foo");
    var profile = construct(this.web3, BitProfile.Profile, info[0]);

    if(!profile.authenticate.call(this.web3.eth.accounts[0], "", 1)) return false;
    if(!profile.authenticate.call(this.web3.eth.accounts[0], "", 2)) return false;
    if(!profile.authenticate.call(this.web3.eth.accounts[0], "", 3)) return false;

    return true;
}

RegistrarTest.prototype.createProfileError = function()
{
    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];

    if(!execute(this.web3, this.registrar.register, this.registrar, ["foo", ""])) return false;
    if(!this.registrar.contains.call("foo")) return false;

    var info = this.registrar.get.call("foo");
    var profile = construct(this.web3, BitProfile.Profile, info[0]);

    if(profile.authenticate.call(this.web3.eth.accounts[1], "", 1)) return false;
    if(profile.authenticate.call(this.web3.eth.accounts[1], "", 2)) return false;
    if(profile.authenticate.call(this.web3.eth.accounts[1], "", 3)) return false;

    return true;
}


RegistrarTest.prototype.linkProfile = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var auth = deploy(this.web3, BitProfile.AddressAuth, [this.web3.eth.defaultAccount]);
    var profile = deploy(this.web3, BitProfile.Profile, [auth.address]);
    if(!profile) return false;
    if(!execute(this.web3, this.registrar.link, this.registrar, ["bar", profile.address, ""])) return false;
    if(!this.registrar.contains.call("bar")) return false;
    var info = this.registrar.get.call("bar");
    return info[0]==profile.address
}

RegistrarTest.prototype.linkProfileAuthError = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var auth = deploy(this.web3, BitProfile.AddressAuth, [this.web3.eth.defaultAccount]);
    var profile = deploy(this.web3, BitProfile.Profile, [auth.address]);
    if(!profile) return false;
    this.web3.eth.defaultAccount = this.web3.eth.accounts[1];
    if(!execute(this.web3, this.registrar.link, this.registrar, ["foobar", profile.address, ""])) return false;
    if(this.registrar.contains.call("foobar")) return false;
    return true;
}

RegistrarTest.prototype.linkProfileDuplicateError = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var auth = deploy(this.web3, BitProfile.AddressAuth, [this.web3.eth.defaultAccount]);
    var profile = deploy(this.web3, BitProfile.Profile, [auth.address]);
    if(!profile) return false;
    if(!execute(this.web3, this.registrar.link, this.registrar, ["bar", profile.address, ""])) return false;
    if(this.registrar.contains.call("foobar")) return false;
    return true;
}

RegistrarTest.prototype.moveContext = function(){
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    var context = this.registrar.getContext.call();
    if(!context) return false;
    var registrar = deploy(this.web3, BitProfile.Registrar, [context, this.factory.address, this.web3.eth.defaultAccount]);
    if(!registrar) return false;
    if(!execute(this.web3, this.registrar.moveContext, this.registrar, [registrar.address])) return false;
    if(!registrar.contains.call("bar")) return false;

    if(!execute(this.web3, registrar.register, registrar, ["foo2", ""])) return false;
    if(!registrar.contains.call("foo2")) return false;

    if(!execute(this.web3, this.registrar.register, this.registrar, ["foo3", ""])) return false;
    if(this.registrar.contains.call("foo3")) return false;

    this.registrar = registrar;

    return true;
}

RegistrarTest.prototype.unlinkProfileAuthError = function()
{
    if(!execute(this.web3, this.registrar.unlink, this.registrar, ["bar", ""], this.web3.eth.accounts[1])) return false;
    if(!this.registrar.contains.call("bar")) return false;
    return true;
}

RegistrarTest.prototype.unlinkProfile = function(){
    if(!execute(this.web3, this.registrar.unlink, this.registrar, ["bar", ""], this.web3.eth.accounts[0])) return false;
    if(this.registrar.contains.call("bar")) return false;
    return true;
}




module.exports = RegistrarTest;
