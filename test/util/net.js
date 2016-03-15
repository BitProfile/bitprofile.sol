var net = require('net');
var deasync = require('deasync');



net.Socket.prototype.writeSync = function(request){

    var buffer = "";
    var readDone = false, writeDone = false;
    var error = undefined;

//    console.log("request : ",request);
    var requestJSON = JSON.parse(request);

    var readCallback = function(data){
        var json = JSON.parse(data.toString());
        if(json["id"]==requestJSON["id"])
        {
            buffer += data.toString();
//            console.log("response: ",buffer);
            readDone = true;
        }
//        else
//        {
//            console.log("id not matched : ",data.toString());
//        }
    }
    this.on('data', readCallback);

    this.write(request, function(err){
//        console.log("write done: ",arguments);
        writeDone = true;
        error = err;
    })

    while(!writeDone){
        deasync.runLoopOnce();
    }

    if(error){
        throw error;
    }

    while(!readDone)
    {
        deasync.runLoopOnce();
    }

    this.removeListener("data", readCallback);

    return buffer;
}





module.exports = net;
