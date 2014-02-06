# * grunt-browserifying
# * https://github.com/thesunny/grunt-browserifying
# *
# * Copyright (c) 2014 Sunny Hirai
# * Licensed under the MIT license.
# 
"use strict"

fs = require 'fs'
path = require 'path'
coffeeify = require 'coffeeify'
_ = require 'lodash'

resolveShimOptions = (options) ->
  _.each options, (value, key) ->
    value.path = path.resolve(value.path)


module.exports = (grunt) ->
  
  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "browserifying", "Continuously Browserify JavaScript and CoffeeScript files fast (it caches)", ->

    # Runs this in asynchronous mode. Sets up a function to call when we want
    # to exit.
    quit = @async()

    # get options with defaults
    options = @options(
      watch: false
      debug: false
      brfs: false
      aliasMappings: null
      shim: null
    )

    @files.forEach (file) ->
      sourcePaths = file.orig.src
      destPath = file.orig.dest

      browserifyOptions = {
        extensions: [".coffee"]
      }

      # Create a browserify instance that accepts both .js and .coffee files.
      # Note that Watchify returns a Browserify instance except that it caches
      # making Browserify run a lot faster after the first bundle.
      if options.watch
        watchify = (require 'watchify')(browserifyOptions)
      else
        watchify = (require 'browserify')(browserifyOptions)

      # # Create a watchify instance that accepts both .js and .coffee files.
      # # Watchify returns a Browserify instance except that it caches making
      # # Browserify run a lot faster after the first bundle.
      # watchify = watchifyModule(watchifyOptions)

      # Add all the source paths the .files configuration.
      _.each sourcePaths, (sourcePath) ->
        watchify.add sourcePath

      # Add the CoffeeScript transform. The CoffeeScript transform is added
      # first so that the other transforms are working on top of JavaScript
      # code instead of CoffeeScript code.
      watchify.transform(coffeeify)

      # Add browserify-shim only if options.shim is defined.
      if options.shim?
        shim = require 'browserify-shim'
        shimOptions = resolveShimOptions(options.shim)
        resolveShimOptions(shimOptions)
        shim(watchify, shimOptions)

      # Add alias support using aliasify plugin
      aliasify = require("aliasify").configure
        aliases: options.alias
      watchify.transform(aliasify)

      # Add BRFS support if requested
      if options.brfs
        watchify.transform('brfs')

      bundleOptions = {
        # The default is to include the source maps
        debug: options.sourceMaps || true
        # These are actually the default values but added here for clarity
        insertGlobals: false   # don't auto insert globals
        detectGlobals: true    # only insert if a global is referenced
      }

      # Create a bundle function that gets called whenever a file is updated.
      # We put it in a separate function because we also need to call the
      # bundle once manually and separately from the callback. If we don't
      # do this, then watchify doesn't keep the process open (i.e. it
      # immediately exits)
      bundle = ->
        watchify.bundle bundleOptions, (err, src) ->
          if err
            grunt.log.error err
          else
            fs.writeFile destPath, src, (err) ->
              if err
                grunt.log.error err
              else
                console.log "browserifying done."


      # watchify.on "file", (file, id, parent) ->
      #   console.log "on file:", id

      console.log "-------------------"
      console.log "grunt-browserifying"
      console.log "-------------------"

      # watch for file changes. When there is one, then we call bundle()
      if options.watch
        watchify.on "update", (id) ->
          console.log "browserifying #{id.join(', ')}"
          bundle()
        console.log "Watching #{sourcePaths}"
      else
        console.log "Not watching. To watch, add option {watch: true} to Gruntfile."

      console.log "browserifying #{sourcePaths.join(', ')}"
      bundle()