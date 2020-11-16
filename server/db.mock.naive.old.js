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
    for (var reqExSet of reqList) {
        
        // If it's not in the dbList, user wants to add
        //
        if (!dbList.includes(reqExSet)) {
            console.log('adding ' + reqExSet)
            
            setTimeout(function(){
                console.log('added ' + reqExSet)
                dbList.push(reqExSet)
                console.log(dbList)
            }, 200)
        }
    }

    // Loop through the current dbList, see what is not in the reqList, and if 
    // it's not there, the user wants to delete it, so we delete it
    //
    for (var dbExSet of dbList) {
        
        // If it's not in the reqList, user wants to delete it
        //
        if (!reqList.includes(dbExSet)) {
            console.log('deleting ' + dbExSet)

            setTimeout(function(){
                console.log('deleted ' + dbExSet)
                
                deleted.push(dbExSet)
                console.log(dbList)
            }, 200)
        }

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
