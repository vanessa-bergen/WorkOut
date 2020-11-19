module.exports = function(res, code, err, msg, extras){
    var getErrMsg = function(err){
        if (err.errors){
            for (var name in err.errors){
                if (err.errors[name].message)
                    return err.errors[name].message;
            }
        }
        return "no msg";
    };

    var jsonErr = {
        err : err
    };

    if (msg){
        jsonErr.msg = msg;                     
    } else {
        jsonErr.msg = getErrMsg(err);
    }

    if (extras){
        for (var e in extras) jsonErr[e] = extras[e];
    }

    console.log('\n    ' + JSON.stringify(jsonErr));

    return res.status(code).json(jsonErr);
}
