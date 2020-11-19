var mongoose = require('mongoose')

var Schema = mongoose.Schema

var ExerciseSchema = Schema ({
    name : {
        type : String,
        unique : true,
        required : true
    },
    description : {
        type : String
    }
})

mongoose.model('Exercise', ExerciseSchema)
