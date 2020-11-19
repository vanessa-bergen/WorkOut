var express = require('express')
var morgan = require('morgan')
var bodyParser = require('body-parser')
var session = require('express-session')

module.exports = function() {
    console.log('initializing workout.js...')

    var app = express()

    app.use(morgan('dev'))
    app.use(bodyParser.urlencoded({ extended : true }))
    app.use(bodyParser.json())
    app.use(session({
        saveUninitialized : true,
        resave : true,
        secret : "blahblahblahblah",
        cookie : {
            maxAge : 1000 * 3600 * 24
        }
    }))

    console.log("    initializing routes...")

    require('../app/hello.world/routes.js')(app)
    require('../app/sample/routes.js')(app)
    require('../app/exercise/routes.js')(app)
    require('../app/exerciseSet/routes.js')(app)
    require('../app/workout/routes.js')(app)

    console.log("    routes intialized.")

    return app
}
