#
# * grunt-browserifying
# * https://github.com/thesunny/grunt-browserifying
# *
# * Copyright (c) 2014 Sunny Hirai
# * Licensed under the MIT license.
# 
"use strict"

require 'coffee-script/register'

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

    
    # Configuration to be run (and then tested).
    browserifying:

      alias:
        options:
          watch: false
          map:
            "alias": "./example/alias/alias.js"
        files:
          "./tmp/alias.js": "./example/alias/index"

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
      tests: ["test/*_test.coffee"]

  
  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"
  
  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"
  
  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", [
    "clean"
    "browserifying:simple"
    "browserifying:alias"
    "browserifying:shim"
    "browserifying:coffee"
    "browserifying:glob"
    "browserifying:integrated"
    "nodeunit"
  ]
  
  # By default, lint and run all tests.
  grunt.registerTask "default", [
    "test"
  ]
