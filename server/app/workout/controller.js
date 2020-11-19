module.exports = function() {
    var ExerciseSet = require('mongoose').model('ExerciseSet')
    var Workout = require('mongoose').model('Workout')
    var reqError = require('../common/reqError.js')

    var c = {}

    c.create = function(req, res) {
        console.log(JSON.stringify(req.body))

        // remove the _id fields in the request body, mongoose will generate the _ids
        exSets = req.body.exerciseList.map(function(item) {
            delete item._id
            return item
        })

        ExerciseSet.insertMany(exSets, function(err, exerciseSets) {
            if (err) return reqError(res, 500, err)

            console.log(JSON.stringify(exerciseSets))
            
            var newArray = exerciseSets.map(x => x._id)
            console.log(newArray)
            //res.status(201).json(exerciseSets)
            
            
            var newWorkout = new Workout({ 
                name : req.body.name,
                description : req.body.description,
                exerciseList : newArray
            })

            newWorkout.save(function(err) {
                if (err) return reqError(res, 500, err)

                //res.status(201).json(newWorkout)
                newWorkout.populate({ path : 'exerciseList', populate : { path : 'exercise' }}, function(err, newWorkout) {
                    res.status(201).json(newWorkout)
                })
            })
        })
    }

    c.update = function(req, res) {
        console.log(" request body " + JSON.stringify(req.body))
        
        var async = require('async')

        var tasks = []
        
        Workout.findOne( { _id : req.body._id }, function(err, workout) {
            if (err) return reqError(res, 500, err)
            // update the workout name and description with the request
            workout.name = req.body.name
            workout.description = req.body.description

            console.log("exercise sets" + JSON.stringify(workout.exerciseList))

            // Target workout exercise set: what the user has requested
            // the final set of exercises for the workout to be
            //
            var targetExSets = {}

            // Create the requested final set
            // Dictionary with the exerciseSet ID as the key, exerciseSet object as the value
            //
            for (var reqExSet of req.body.exerciseList) {
               targetExSets[reqExSet._id] = reqExSet
            }
            console.log("request target " + targetExSets)

            // Loop through what is currently in the db
            // any exerciseSets in the db and not in the request are marked to be removed
            // any exerciseSets that exist in both the db and the request are marked to be updated
            //
            var setsToRemove = []
            var setsToUpdate = []

            for (var dbExSet of workout.exerciseList) {
                // Remove any exerciseSets the user has requested to delete
                //
                if (!(dbExSet in targetExSets)) {
                   // want to remove the set from the workout, add to list of items to be removed                   //
                   setsToRemove.push(dbExSet)
                   
                } else {
                    // Want to update sets that are in the request and db
                    // place the whole requested exerciseSet object in the list
                    // the request body will be used to update the record
                    setsToUpdate.push(targetExSets[dbExSet])
                    
                    // After the exerciseSet is added to the update list, delete it from the targetExSets dictionary
                    // this way all exerciseSets that remain in the dictionary are sets that will need to be created
                    // 
                    delete targetExSets[dbExSet]

               }

             }

            async.forEach(setsToRemove, function(exSet) {
                console.log("deleting " + exSet)

                tasks.push(
                    function(callback) {
                        workout.exerciseList.pull({ _id : exSet })
                        console.log("exercise list with delete " + workout.exerciseList)
                        callback(null, workout.exerciseList)
                    }
                )
            })

            async.forEach(setsToUpdate, function(exSet) {
                console.log("updating " + exSet._id)

                tasks.push(
                    function(callback) {
                        // find the exerciseSet using the id and update it with the data from the request body
                        //
                        ExerciseSet.findOneAndUpdate({ _id : exSet._id }, { $set : exSet }, { new : true }, function(err, updatedSet) {
                            console.log("updated set " + JSON.stringify(updatedSet))
                            callback(err, workout.exerciseList)
                        })
                    }
                )
            })

            // Loop through and remaining sets in the setsDict
            // these are the exerciseSets that the user is requesting to add
            // need to create these sets with the request body
            //
            var setsToAdd = []
            for (var reqSetId in targetExSets) {
                setsToAdd.push(targetExSets[reqSetId])
            }

            console.log("sets to remove " + setsToRemove)
            console.log("sets to update " + setsToUpdate)
            console.log("sets to add " + setsToAdd)

            async.forEach(setsToAdd, function(exSet) {
                console.log("adding " + exSet._id)

                tasks.push(
                    function(callback) {
                        // create the new exerciseSet object
                        //
                        var newSetObj = {
                            exercise : exSet.exercise,
                            time : exSet.time,
                            restTime : exSet.restTime,
                            order : exSet.order
                        }
                        
                        var newExerciseSet = new ExerciseSet(newSetObj)
                        
                        newExerciseSet.save(function(err) {
                            
                            console.log("new exercise set " +  JSON.stringify(newExerciseSet))
                            // Add the new exercise set to the workout
                            workout.exerciseList.push(newExerciseSet._id)

                            callback(err, workout.exerciseList)
                        })
                    }
                )
            })

            async.parallel(tasks, function(err, results) {
                console.log('final ')
                // done all the calls to the database
                // save the workout object
                //
                workout.save(function(err) {
                    if (err) return reqError(res, 500, err)
                    // send the status code and updated workout object
                    //
                    res.status(200).json({ updatedWorkout : workout })
                })
            })
         })
    }
             
    c.delete  = function(req, res) {
        var async = require('async')
        var tasks = []

        // loop through all exerciseSets in the workout
        // delete each exerciseSet
        //
        async.forEach(req.body.exerciseList, function(set) {
            console.log("removing set " + set._id)
            
            tasks.push(
                function(callback) {
                    ExerciseSet.findOneAndDelete({ _id : set._id }, function(err, exerciseSet) {
                        console.log("deleted set " + JSON.stringify(exerciseSet))
                        callback(err, exerciseSet)
                    })
                }
            )
        })

        // once all exersiceSets have been deleted, delete the workout
        //
        async.parallel(tasks, function(err, results) {
            Workout.findOneAndDelete({ _id : req.body._id }, function(err, workout) {
                if (err) return reqError(res, 500, err)
                console.log("Workout deleted " + workout._id)
                res.status(200).json({ workoutDeleted : workout })
            })
        })
    }



    c.getAll = function(req,res) {
        var q = Workout.find({}, "-__v")
        
        q.populate({
            // populate each exerciseSet in the exerciseList
            path : 'exerciseList',
            // populate each exercise in the exerciseSet
            populate : { path : 'exercise' }
        })
        q.sort('name')
        q.exec(function(err, workouts) {
            res.json(workouts)
        })
    }

    return c
}
