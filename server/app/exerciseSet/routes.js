module.exports = function(app) {
    var ctrl = require('./controller.js')()

    app.post('/exerciseSet', ctrl.create)
    app.post('/exerciseSet2', ctrl.createSmart)
    app.get('/exerciseSet', ctrl.getAll)

    console.log('   exerciseSet routes initialized.')
}
