module.exports = function(app) {
    var ctrl = require('./controller.js')()

    app.post('/sample', ctrl.create)

    app.get('/sample', ctrl.getAll)

    console.log('    sample routes initialized.')
}
