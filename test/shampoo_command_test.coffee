"use strict"

grunt = require("grunt")
path = require("path")
child_process = require('child_process')
_ = require 'lodash'
util = require './util'
cwd = process.cwd()

# Add methods onto String without actually modifying the String object.
# Here to aid in testing.
class StringClass
  constructor: (@s) ->
  has: (subString) ->
    @s.indexOf(subString) != -1

# Shortcut to create a new StringClass object
S = (s) ->
  new StringClass(s)

# Spawns a shampoo.js command line process and gives it the passed in args.
# When it's finished, ie runs the callback.
run = (args, callback) ->
  throw "args must be an Array" if !_.isArray(args)
  throw "callback must be a function" if !_.isFunction(callback)
  child = child_process.spawn('node', ['shampoo.js'].concat(args))
  child.stdout.pipe(process.stdout)
  child.stderr.pipe(process.stderr)
  child.on 'exit', callback
  child



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
exports.shampoo_command =
  setUp: (done) ->
    done()

  # single source
  two_path_arguments: (test) ->
    child = run ['tmp/two', 'example/simple/alpha', '-o'], =>
      s = util.read 'tmp/two.js'
      test.ok s.has('console.log("alpha");'), "includes alpha"
      test.ok s.has('module.exports = "bravo";'), "includes bravo"
      test.done()

  # two sources
  three_path_arguments: (test) ->
    child = run ['tmp/three', 'example/two_source/index-1', 'example/two_source/index-2', '-o'], =>
      s = util.read 'tmp/three.js'
      test.ok s.has('console.log("index-1.coffee")', "includes index-1")
      test.ok s.has('console.log("index-2.js")', "includes index-2")
      test.done()

  # init shampoojs and use it
  init_js: (test) ->
    child = run ['--init-js'], =>
      test.ok grunt.file.exists(cwd + '/Shampoofile.js')
      grunt.file.delete(cwd + '/Shampoofile.js')
      test.ok !grunt.file.exists(cwd + '/Shampoofile.js')
      test.done()

  # init shampoojs and use it
  init_coffee: (test) ->
    child = run ['--init-coffee'], =>
      test.ok grunt.file.exists(cwd + '/Shampoofile.coffee')
      grunt.file.delete(cwd + '/Shampoofile.coffee')
      test.ok !grunt.file.exists(cwd + '/Shampoofile.coffee')
      test.done()
