var net = require('net');
var deasync = require('deasync');


net.Socket.prototype.writeSync = function(request){

    var lastError = undefined;
    var errors = 0;
    do
    {
        try
        {
            return this.executeRequest(request);
        }
        catch(e)
        {
            errors++;
            lastError = e;
            console.log("got rpc error : ",e);
        }
    }
    while(errors<3);

    throw lastError;
}


net.Socket.prototype.executeRequest = function(request){

    var buffer = "";
    var readDone = false, writeDone = false;
    var error = undefined;

//    console.log("request : ",request);
    var requestJSON = JSON.parse(request);

    var readCallback = function(data){
        try
        {
            var json = JSON.parse(data.toString());
            if(json["id"]==requestJSON["id"])
            {
                buffer += data.toString();
//            console.log("response: ",buffer);
                readDone = true;
            }
        }
        catch(e)
        {
            error = e;
        }
    }
    this.on('data', readCallback);

    this.write(request, function(err){
        writeDone = true;
        error = err;
    });

    while(!writeDone){
        deasync.runLoopOnce();
    }

    while(!readDone&&!error)
    {
        deasync.runLoopOnce();
    }

    this.removeListener("data", readCallback);

    if(error)
    {
        throw error;
    }

    return buffer;
}





module.exports = net;
