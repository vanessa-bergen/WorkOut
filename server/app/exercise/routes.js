module.exports = function(app) {
    var ctrl = require('./controller.js')()

    app.post('/exercise', ctrl.create)
    app.get('/exercise', ctrl.getAll)
    app.put('/exercise/edit', ctrl.update)
    app.delete('/exercise/delete', ctrl.delete)

    console.log('   exercise routes initialized.')
}
