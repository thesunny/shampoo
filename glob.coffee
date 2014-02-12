glob = require 'glob'
console.log '---not a glob---'
console.log glob.sync('example/glob/glob-1.coffee')
console.log '---glob---'
console.log glob.sync('example/glob/**/*.coffee')
