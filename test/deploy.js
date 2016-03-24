var BitProfile = require('bitprofile-contract');

var Web3 = require('web3');
var deploy = require('./util/contract/deploy');
var net = require('./util/net');

if(process.argv.length<6)
{
    console.log("usage: test.js [ipc path] [accont] [password] [beta interval] [beta limit]");
    process.exit(1);
}


var web3 = new Web3();
web3.setProvider(new web3.providers.IpcProvider(process.argv[2], net));

var result = web3.personal.unlockAccount(process.argv[3], process.argv[4]);
console.log(process.argv[3], " unlock : ",result)
if(!result) process.exit(1);

web3.eth.defaultAccount = process.argv[3];

var profileFactory = deploy(web3, BitProfile.ProfileFactory, []);
var registrarFactory = deploy(web3, BitProfile.RegistrarFactory, [profileFactory.address]);
var master = deploy(web3, BitProfile.MasterRegistrar, [process.argv[5], process.argv[6], registrarFactory.address]);

if(master)
{
    console.log("master registrar deployed at "+master.address);
}
else
{
    console.log("failed to deploy master registrar");
}

process.exit(0);
