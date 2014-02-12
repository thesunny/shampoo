fs = require 'fs'

require './include-1'
require './include-2'
require 'aliasMap-1'
require "aliasMap-2"
console.log(require "shim-1")
console.log(require "shim-2")

helloWorldText = fs.readFileSync(__dirname + '/hello-world.txt')
console.log helloWorldText

console.log "example-1"