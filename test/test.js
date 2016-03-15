var Web3 = require('web3');

var AddressAuthTest = require('./case/AddressAuthTest');
var ProfileTest = require('./case/ProfileTest');
var RegistrarTest = require('./case/RegistrarTest');
var MasterRegistrarTest = require('./case/MasterRegistrarTest');


var execute = require('./util/execute');
var net = require('./util/net');

if(process.argv.length<3)
{
    console.log("usage: test.js [ipc path] [password]");
    process.exit(1);
}

var web3 = new Web3();
web3.setProvider(new web3.providers.IpcProvider(process.argv[2], net));

if(web3.eth.accounts.length<3)
{
    console.log("required min 2 ethereum accounts");
    process.exit(1);
}

var result = web3.personal.unlockAccount(web3.eth.accounts[0], process.argv[3]);
console.log(web3.eth.accounts[0], " unlock : ",result)
if(!result) process.exit(1);


result = web3.personal.unlockAccount(web3.eth.accounts[1], process.argv[3]);
console.log(web3.eth.accounts[1], " unlock : ",result)
if(!result) process.exit(1);


execute(new AddressAuthTest(web3));
execute(new ProfileTest(web3));
execute(new RegistrarTest(web3));
execute(new MasterRegistrarTest(web3));


process.exit(0);

