var mongoose = require('mongoose')

var Schema = mongoose.Schema

var WorkoutSchema = new Schema({
    name : {
        type : String,
        required : true,
        unique : true
    },
    description : {
        type : String
    },
    exerciseList : {
        type : [{
            type : Schema.Types.ObjectId,
            ref : 'ExerciseSet'
        }],
        default : []
    }
})

mongoose.model('Workout', WorkoutSchema)

