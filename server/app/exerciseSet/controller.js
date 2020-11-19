module.exports = function() {
    var Exercise = require('mongoose').model('Exercise')
    var ExerciseSet = require('mongoose').model('ExerciseSet')
    var reqError = require('../common/reqError.js')

    var c = {}

    c.create = function(req, res) {
        console.log(JSON.stringify(req.body))
        
        delete req.body._id
        var newExerciseSet = new ExerciseSet(req.body)

        newExerciseSet.save(function(err) {
            if (err) return reqError(res, 500, err)

            newExerciseSet.populate('exercise', function(err, newExerciseSet) {
                res.status(201).json(newExerciseSet)
            })
            //res.populate({ path : 'exercise' })
            //res.status(201).json(newExerciseSet)
        })
    }

    c.createSmart = function(req, res) {
        console.log(JSON.stringify(req.body))

        var exerciseQ = Exercise.findOne({name : req.body.name}, "-__v")
        exerciseQ.exec(function(err, exercise) {
            if (err) return reqError(res, 500, err)

            console.log(JSON.stringify(exercise))

            var newExObj = {
                exercise : exercise._id,
                time : req.body.time,
                restTime : req.body.restTime,
                order : req.body.order
            }

            console.log(newExObj)

            var newExerciseSet = new ExerciseSet(newExObj)

            newExerciseSet.save(function(err) {
                if (err) return reqError(res, 500, err)

                res.status(201).json(newExerciseSet)
            })
        })
    }

    c.getAll = function(req, res) {
        var q = ExerciseSet.find({}, "-__v")
        
        q.populate({
            path : 'exercise'
        })
        q.sort('exercise.name')
        q.exec(function(err, exerciseSets) {
            if (err) return reqError(res, 500, err)

            res.json(exerciseSets)
        })
    }

    return c
}
