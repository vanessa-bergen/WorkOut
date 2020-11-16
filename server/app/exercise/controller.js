module.exports = function() {
    var Exercise = require('mongoose').model('Exercise')
    var ExerciseSet = require('mongoose').model('ExerciseSet')
    var Workout = require('mongoose').model('Workout')
    var reqError = require('../common/reqError.js')

    var c = {}

    c.create = function(req, res) {
        console.log(JSON.stringify(req.body))

        delete req.body._id

        var newExercise = new Exercise(req.body)

        newExercise.save(function(err) {
            if (err) return reqError(res, 500, err)

            res.status(201).json(newExercise)
        })
    }

    c.getAll = function(req, res) {
        var q = Exercise.find({}, "-__v")

        q.sort('name')
        q.exec(function(err, exercises) {
            if (err) return reqError(res, 500, err)

            res.json(exercises)
        })
    }

    c.update = function(req, res) {
        Exercise.findOneAndUpdate({ _id : req.body._id }, { $set : req.body }, { new : true }, function(err, updatedExercise) {
            if (err) return reqError(res, 500, err)

            res.status(200).json({ updatedExercise : updatedExercise })
        })
    }

    c.delete = function(req, res) {
        var async = require('async')
        var tasks = []
        
        // find all exerciseSets that contain the exercise that will be deleted
        //
        ExerciseSet.find({ exercise : req.body._id }, function(err, exerciseSets) {
            //if (err) return reqError(res, 500, err)
            
            console.log("all exercise sets with the exercise " + JSON.stringify(exerciseSets))
            
            
            // loop through each exerciseSet and find the workout it belongs to
            //
            async.forEach(exerciseSets, function(set) {
                console.log("removing " + set)
                tasks.push(
                    function(callback) {
                        // each exercise set will belong to one workout
                        // find the workout and remove the exerciseSet from the exerciseList
                        //
                        Workout.findOneAndUpdate({ exerciseList : { $elemMatch : { $eq :  set._id }}}, { $pull : { exerciseList : set._id }}, function(err, workout) {

                            console.log("workout found " + JSON.stringify(workout))
                            callback(err, workout)
                        })
                    }
                )

                tasks.push(
                    function(callback) {
                        // delete the exerciseSet from the db
                        //
                        ExerciseSet.findOneAndDelete({ _id : set._id}, function(err, exerciseSet) {
                            console.log("deleted set " + JSON.stringify(exerciseSet))
                            callback(err, exerciseSet)
                        })
                    }
                )
            })
        

            // Once all the exerciseSets associated with the exercise have been removed from the workouts and deleted, the exercise can be deleted
            //
            async.parallel(tasks, function(err, results) {
                console.log('complete cascade deletes')
                console.log('deleting the exercise')
                Exercise.findOneAndDelete({ _id : req.body._id }, function(err, exercise) {
                    if (err) return reqError(res, 500, err)
                    res.status(200).json({ exerciseDeleted : exercise })
                })
            })
        })
    }

    return c
}
