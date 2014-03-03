grunt = require 'grunt'

# Add methods onto String without actually modifying the String object.
# Here to aid in testing.
class StringClass
  constructor: (@string) ->
  has: (subString) ->
    @string.indexOf(subString) != -1

# Shortcut to create a new StringClass object
S = (s) ->
  new StringClass(s)

module.exports =
  read: (path) ->
    new StringClass(grunt.file.read(path))
