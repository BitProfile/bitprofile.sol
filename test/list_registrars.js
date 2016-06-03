var BitProfile = require('bitprofile-contract');

var Web3 = require('web3');
var execute = require('./util/contract/execute');
var construct = require('./util/contract/construct');
var net = require('./util/net');

if(process.argv.length<4)
{
    console.log("usage: list_registrars.js [ipc path] [master contract]");
    process.exit(1);
}


var web3 = new Web3();
web3.setProvider(new web3.providers.IpcProvider(process.argv[2], net));

var master = construct(web3, BitProfile.MasterRegistrar, process.argv[3]);

console.log("size : ", master.size.call());
console.log("beta: ", master.beta.call());


process.exit(0);
