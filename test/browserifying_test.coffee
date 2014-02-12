"use strict"

grunt = require("grunt")

class StringClass
  constructor: (@s) ->
  has: (subString) ->
    @s.indexOf(subString) != -1

S = (s) ->
  new StringClass(s)

#  ======== A Handy Little Nodeunit Reference ========
#  https://github.com/caolan/nodeunit
#
#  Test methods:
#    test.expect(numAssertions)
#    test.done()
#  Test assertions:
#    test.ok(value, [message])
#    test.equal(actual, expected, [message])
#    test.notEqual(actual, expected, [message])
#    test.deepEqual(actual, expected, [message])
#    test.notDeepEqual(actual, expected, [message])
#    test.strictEqual(actual, expected, [message])
#    test.notStrictEqual(actual, expected, [message])
#    test.throws(block, [error], [message])
#    test.doesNotThrow(block, [error], [message])
#    test.ifError(value)
#
exports.browserifying =
  setUp: (done) ->
    # setup here if necessary
    done()

  simple: (test) ->
    s = S(grunt.file.read("tmp/simple.js"))
    test.ok s.has('console.log("alpha");'), "includes alpha"
    test.ok s.has('module.exports = "bravo";'), "includes bravo"
    test.done()

  alias: (test) ->
    s = S(grunt.file.read("tmp/alias.js"))
    test.ok s.has('module.exports = "index.js"'), "includes index.js"
    test.ok s.has('module.exports = "alias.js"'), "includes index.js"
    test.done()

  shim: (test) ->
    s = S(grunt.file.read("tmp/shim.js"))
    test.ok s.has('module.exports = "index.js";'), "includes index.js"
    test.ok s.has('"shim.coffee"'), "includes shim.coffee"
    test.ok s.has('$ : window.$'), "includes the shim"
    test.done()

  coffee: (test) ->
    s = S(grunt.file.read('tmp/coffee.js'))
    test.ok s.has("console.log('index.coffee');"), "includes index.coffee"
    test.ok s.has('module.exports = "other.js";'), "includes other.js"
    test.done()

  glob: (test) ->
    s = S(grunt.file.read("tmp/glob.js"))
    test.ok s.has('"glob-1"'), "has glob-1"
    test.ok s.has('"glob-2"'), "has glob-2"
    test.done()

  watch: (test) ->
    console.log ""
    console.log "============================"
    console.log "YOU MUST MANUALLY TEST WATCH"
    console.log "----------------------------"
    console.log "> grunt browserifying:watch"
    console.log ""
    console.log "make changes to file in watch ./example/watch"
    console.log "make sure on every save file gets rebuilt"
    test.done()

  