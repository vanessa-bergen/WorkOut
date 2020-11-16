var mongoose = require('mongoose')

var Schema = mongoose.Schema

var SampleSchema = Schema({
    name : {
        type : String, 
        required : true,
        unique : true
    }
})

mongoose.model('Sample', SampleSchema)
