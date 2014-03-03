#
# * ShampooJS
# * https://github.com/thesunny/shampoojs
# *
# * Copyright (c) 2014 Sunny Hirai
# * Licensed under the MIT license.
# 
"use strict"

module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
    # jshint:
    #   all: [
    #     "Gruntfile.js"
    #     "tasks/*.js"
    #     # "<%= nodeunit.tests %>"
    #   ]
    #   options:
    #     jshintrc: ".jshintrc"

    
    # Before generating any new files, remove any previously-created files.
    clean:
      tests: ["tmp"]

    connect:
      server:
        options:
          port: 9001
          base: '.'
          keepalive: true

    
    # Configuration to be run (and then tested).
    shampoo:

      alias:
        options:
          watch: false
          map:
            "alias": "./example/alias/alias.js"
        files:
          "./tmp/alias.js": "./example/alias/index.js"

      shim:
        options:
          watch: false
          map:
            "shim":
              exports: '$'
              path: "./example/shim/shim.coffee"
        files:
          "./tmp/shim.js": "./example/shim/index"

      coffee:
        options:
          watch: false
        files:
          "./tmp/coffee.js": "./example/coffeejs/index"

      integrated:
        options:
          map:
            "aliasMap-1": "./example/integrated/aliasMappings/aliasMap-1"
            "aliasMap-2": "./example/integrated/aliasMappings/aliasMap-2"
            "shim-1":
              path: "./example/integrated/shims/shim-1"
              exports: "$"

            "shim-2":
              path: "./example/integrated/shims/shim-2"
              exports: "$"
          brfs: true
          watch: false
        files:
          "./tmp/integrated.js": [
            "./example/integrated/example-1.coffee"
            "./example/integrated/example-2.js"
          ]

      simple:
        options:
          watch: false

        files:
          "./tmp/simple.js": ["./example/simple/alpha"]

      prefix:
        options:
          watch: false
        files:
          "tmp/prefix.js": "example/simple/alpha"

      extension:
        options:
          watch: false
        files:
          "tmp/extension": "example/simple/alpha"

      extensions:
        options:
          watch: false
          extensions: ['.jsx']
        files:
          "tmp/extensions": "example/extensions/index"

      glob:
        options:
          watch: false

        files:
          "./tmp/glob.js": ["./example/glob/**/*.coffee"]

      watch:
        files:
          "./tmp/watch.js": "./example/watch/index"


    
    # Unit tests.
    nodeunit:
      grunt: ["test/*_test.coffee"]
      command: ["test/shampoo_command_test.coffee"]

  
  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"
  
  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"
  grunt.loadNpmTasks "grunt-contrib-connect"
  
  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", [
    "clean"
    "shampoo:simple"
    "shampoo:prefix"
    "shampoo:extension"
    "shampoo:extensions"
    "shampoo:alias"
    "shampoo:shim"
    "shampoo:coffee"
    "shampoo:glob"
    "shampoo:integrated"
    "nodeunit:grunt"
  ]

  # This just runs the command line tests
  grunt.registerTask "test-command", [
    "clean",
    "nodeunit:command"
  ]
  
  # By default, lint and run all tests.
  grunt.registerTask "default", [
    "test"
  ]
