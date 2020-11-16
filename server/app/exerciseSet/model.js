var mongoose = require('mongoose')

var Schema = mongoose.Schema

var ExerciseSetSchema = new Schema({
    exercise : {
        type : Schema.Types.ObjectId,
        ref : 'Exercise',
        required : true
    },
    time : {
        type : Number,
        required : true
    },
    restTime : {
        type : Number,
        required : true
    },
    order : {
        type : Number,
        required : true
    }

})

mongoose.model('ExerciseSet', ExerciseSetSchema)
