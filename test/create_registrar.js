var BitProfile = require('bitprofile-contract');

var Web3 = require('web3');
var execute = require('./util/contract/execute');
var construct = require('./util/contract/construct');
var net = require('./util/net');

if(process.argv.length<5)
{
    console.log("usage: test.js [ipc path] [accont] [password] [master contract]");
    process.exit(1);
}


var web3 = new Web3();
web3.setProvider(new web3.providers.IpcProvider(process.argv[2], net));

var result = web3.personal.unlockAccount(process.argv[3], process.argv[4]);
console.log(process.argv[3], " unlock : ",result)
if(!result) process.exit(1);

web3.eth.defaultAccount = process.argv[3];

var master = construct(web3, BitProfile.MasterRegistrar, process.argv[5]);


if(!execute(web3, master.create, master, []))
{
    console.log("failed to create registrar");
}

process.exit(0);
