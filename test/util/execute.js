var color = require('cli-color');

module.exports = function(test, name){

    if(!name){
        name = test.constructor.name;
    }

    console.log(color.yellow("executing "+name+" suite : "));

    var methods=Object.getPrototypeOf(test);

    for(var i in methods)
    {
        if(!methods[i].call(test))
        {
            console.log(color.red(i+" failed"));
            process.exit(1);
        }
        console.log(color.yellow(i+" passed"));
    }

    console.log(name, " suite complete");
}
