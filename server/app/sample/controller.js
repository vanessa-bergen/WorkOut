module.exports = function() {
    var Sample = require('mongoose').model('Sample')
    var reqError = require('../common/reqError.js')

    var c = {}

    c.create = function(req, res) {
        console.log(JSON.stringify(req.body))
        
        var newSample = new Sample(req.body)

        newSample.save(function(err) {
            if (err) return reqError(res, 500, err)

            res.status(201).json({
                newSample : newSample
            })
        })
    }

    c.getAll = function(req, res) {
        var q = Sample.find({}, "-__v")

        q.sort('name')
        q.exec(function(err, samples) {
            if (err) return reqError(res, 500, err)

            res.json(samples)
        })
    }

    return c
}
