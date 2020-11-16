module.exports = function() {

    var c = {}

    c.say = function(req, res) {
        console.log('helloworld controller - say()')

        res.send("hello world")
    }

    return c
}
