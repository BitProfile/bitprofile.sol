var deasync = require('deasync');

module.exports = function(web3, blocks){
    var start = web3.eth.blockNumber;
    var limit = start+blocks;
    var last;
    console.log("waiting ",blocks," blocks (until block ",limit,")");
    for(;;)
    {
        var height = web3.eth.blockNumber;
        if(last!=height)
        {
            console.log("block : ",height);
            last = height;
        }
        if(height>limit) break;
        else deasync.sleep(5);
//        deasync.runLoopOnce();
    }
}
