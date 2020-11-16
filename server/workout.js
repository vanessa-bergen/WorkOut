var appScript = require('./config/express.js')
var mongoScript = require('./config/mongoose.js')

var db = mongoScript()
var app = appScript()

var port = 3004

app.listen(port, function() {
    console.log('workout.js is now listening on port ' + port)
})
