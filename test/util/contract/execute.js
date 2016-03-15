var deasync = require('deasync');

module.exports = function(web3, method, context, params, account, gas){

    var error = false;
    var mined = false;
    var counter = 0;

    params.push({from:account||web3.eth.defaultAccount, gas:gas||4000000})
    var txid = method.apply(context, params);

    console.log("contract invoked : ",txid);


    var timer = setInterval(function(){
        var tx = web3.eth.getTransaction(txid);
        if(tx.blockNumber){
            mined = true;
            clearInterval(timer);
            console.log("transaction mined : ",tx.blockHash)
        }else{
            counter++;
            if(counter>100000){
                console.log("error : timeout");
                error = true;
            }
        }
    },500);

    while(!error&&!mined)
    {
        deasync.runLoopOnce();
    }

    return !error||mined;

}

