var async = require('async')

var functions = [];

var dbList = []
var reqList = [1, 2, 4, 5]

/*
 * functions.push(
    function(callback) {
        callback(null, dbList)
    });
 */

// Mock a call to the database
// 
setTimeout(function() {
    var dbList = [1, 2, 3]
    var deleted = []

    // Loop through the requeste and add anything to the dbList that the request wants to add
    //
    var adding = []
    for (var reqExSet of reqList) {
        
        // If it's not in the dbList, user wants to add
        //
        if (!dbList.includes(reqExSet)) {
            adding.push(reqExSet)
        }
    }

    // Make the db add calls
    //
    for (var a of adding){
        console.log('adding ' + a)
        
        setTimeout(function(){
            console.log('adding ' + a)
            dbList.push(a)
            console.log(dbList)
        }, 200)
    }

    // Loop through the current dbList, see what is not in the reqList, and if 
    // it's not there, the user wants to delete it, so we delete it
    //
    var deleting = []
    for (var dbExSet of dbList) {
        
        // If it's not in the reqList, user wants to delete it
        //
        if (!reqList.includes(dbExSet)) {
            deleting.push(dbExSet)
        }
    }
    
    // Make the db delete calls
    //
    for (var d of deleting){
        console.log('deleting ' + d)
        
        setTimeout(function(){
            console.log('deleted ' + d)

            deleted.push(d)
            console.log(dbList)
        }, 200)
    }
 
    console.log('Done, returning 200 and dbList = ' + dbList)
    console.log('Deleted = ' + deleted)



}, 200);

console.log('dbList = ' + dbList)





/*
var deleteVal = function(val) {
    console.
}


functions.push(
    function(callback) {
        setTimeout(function() {
            console.log('Task One');
            callback(null, 1);
        }, 200);
    });

functions.push(
    function(callback) {
        setTimeout(function() {
            console.log('Task Two');
            callback(null, 2);
        }, 100);
    });

functions.push(
    function(callback) {
        console.log('Task Three')
        callback(null, 3)
    })

var vals = [0, 1, 2, 3, 4, 5]

async.forEach(vals, function(val) {
    var val = 10 + val
    
    console.log(val)

    functions.push(
        function(callback){
            console.log('Task ' + val)
            callback(null, val)
        })
})

async.parallel(
    functions,
    function(err, results) {
        console.log('res.status(200), results = ')
        console.log(results)
    });

// Task 3
// 10
// 11
// 12
// 13
// 14
// 15
// Task 2
// Task 1
// [ 1, 2, 3 ]


*/
