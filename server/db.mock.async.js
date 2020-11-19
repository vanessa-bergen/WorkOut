var async = require('async')
var dbMockWait = 2000

var functions = [];

var dbList = []
var reqList = [1, 2, 4, 5]

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

    // Make the db add calls, but use async so that local variables are not leaked
    //
    async.forEach(adding, function(a) {
        console.log('adding ' + a)
        
        functions.push(
            function(callback) {
                setTimeout(function(){
                    
                    console.log('add: added ' + a)
                    dbList.push(a)
                    console.log('add: dbList = ' + dbList)
                    callback(null, dbList)
            
                }, dbMockWait)
            })
    })

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
    async.forEach(deleting, function(d) {
        console.log('deleting ' + d)
        
        functions.push(
            function(callback) {
                setTimeout(function(){
                    console.log('delete: deleted ' + d)

                    deleted.push(d)
                    console.log('delete: deletedList = ' + deleted)
                    callback(null, deleted)
                }, dbMockWait)
        })
    })

    async.parallel(
        functions,
        function(err, results) {
            console.log('final: Done')
            console.log('final: results = ' + results)
            console.log('returning: ' + dbList)
            console.log('           minus ' + deleted)
            console.log('final: err = ' + err)
        });
}, dbMockWait);

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
