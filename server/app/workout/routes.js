module.exports = function(app) {
    var ctrl = require('./controller.js')()

    app.post('/workout', ctrl.create)
    app.put('/workout/edit', ctrl.update)
    app.get('/workout', ctrl.getAll)
    app.delete('/workout/delete', ctrl.delete)

    console.log('   workout routes initialized.')
}
