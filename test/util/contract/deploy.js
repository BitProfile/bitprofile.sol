var deasync = require('deasync');

module.exports = function(web3, Definition, params, account, gas){

    var Contract = web3.eth.contract(Definition.info.abiDefinition);
    var address = error = undefined;
    var args = params||[];
    args.push({from: account||web3.eth.defaultAccount, gas: gas||4000000, data: Definition.code});
    args.push(function(e, result){
        error = e;
        if(!e)
        {
            if(result.address)
            {
                console.log('Contract mined! address: ', result.address);
                address = result.address;
            }
            else
            {
                console.log("Contract transaction : ", result.transactionHash);
            }
        }
    });
    Contract.new.apply(Contract, args);

    while(!error&&!address)
    {
        deasync.runLoopOnce();
    }

    if(error){
        console.log("error : ",error);
        return false;
    }

    return Contract.at(address);

}

