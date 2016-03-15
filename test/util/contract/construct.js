module.exports = function (web3, Definition, address){

    var Contract = web3.eth.contract(Definition.info.abiDefinition);
    return Contract.at(address);
}

