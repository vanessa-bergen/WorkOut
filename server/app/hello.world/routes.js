module.exports = function(app) {
    var c = require('./controller.js')()

    app.get('/hello', c.say)
}
