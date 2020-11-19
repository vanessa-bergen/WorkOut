var mongoose = require('mongoose')

module.exports = function() {
    var db = mongoose.connect(
        //'mongodb://chris:ubuntuDoAs1Say@localhost/workout_dev?authSource=admin',
        'mongodb://localhost/workout_dev',
        {
            //user: 'chris',
            //pass: 'ubuntuDoAs1Say',
            useNewUrlParser: true,
            useUnifiedTopology: true,
            useCreateIndex: true,
            useFindAndModify: false
        },
        function(err) {
            console.log(err)
        })

    require('../app/sample/model.js')
    require('../app/exercise/model.js')
    require('../app/exerciseSet/model.js')
    require('../app/workout/model.js')

    return db
}
