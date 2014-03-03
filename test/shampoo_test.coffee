"use strict"

grunt = require("grunt")
path = require("path")

# Add methods onto String without actually modifying the String object.
# Here to aid in testing.
class StringClass
  constructor: (@s) ->
  has: (subString) ->
    @s.indexOf(subString) != -1

# Shortcut to create a new StringClass object
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
exports.shampoo =
  setUp: (done) ->
    # setup here if necessary
    done()

  simple: (test) ->
    s = S(grunt.file.read("tmp/simple.js"))
    test.ok s.has('console.log("alpha");'), "includes alpha"
    test.ok s.has('module.exports = "bravo";'), "includes bravo"
    test.done()

  prefix: (test) ->
    s = S(grunt.file.read("tmp/prefix.js"))
    test.ok s.has('console.log("alpha");'), "includes alpha"
    test.ok s.has('module.exports = "bravo";'), "includes bravo"
    test.done()

  extension: (test) ->
    s = S(grunt.file.read("tmp/extension.js"))
    test.ok s.has('console.log("alpha");'), "includes alpha"
    test.ok s.has('module.exports = "bravo";'), "includes bravo"
    test.done()

  extensions: (test) ->
    s = S(grunt.file.read("tmp/extensions.js"))
    test.ok s.has('console.log("index.jsx")'), "includes index.jsx"
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
    console.log ""
    console.log "============================"
    console.log "YOU MUST MANUALLY TEST WATCH"
    console.log "============================"
    console.log ""
    console.log "Change to this directory from the command line:"
    console.log "> cd #{path.normalize(__dirname + '/..')}"
    console.log ""
    console.log "Run the following from command line:"
    console.log "> grunt shampoo:watch"
    console.log ""
    console.log "Then re-save any file in ./example/watch"
    console.log ""
    console.log "After each save, make sure ./tmp/watch.js is rebuilt"
    console.log ""
    test.done()

  