# * ShampooJS
# * https://github.com/thesunny/shampoojs
# *
# * Copyright (c) 2014 Sunny Hirai
# * Licensed under the MIT license.
# 
"use strict"

mkdirp = require 'mkdirp'
fs = require 'fs'
path = require 'path'
coffeeify = require 'coffeeify'
_ = require 'lodash'
glob = require 'glob'
util = require '../lib/util'

resolveShimOptions = (options) ->
  _.each options, (value, key) ->
    value.path = path.resolve(value.path)


processMap = (map) ->
  aliasMap = {}
  shimMap = {}
  _.each map, (value, key) ->
    if _.isString(value)
      aliasMap[key] = value
    else
      shimMap[key] = value
  {aliasMap: aliasMap, shimMap: shimMap}


module.exports = (grunt) ->
  
  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "shampoo", "The ultimate CommonJS build tool for development and production", ->

    # Runs this in asynchronous mode. Sets up a function to call when we want
    # to exit.
    quit = @async()

    # get options with defaults
    options = @options(
      watch: true
      debug: false
      brfs: false
      aliasMappings: null
      shim: null
      extensions: []
    )

    numBundles = @files.length
    completedBundles = 0

    @files.forEach (file) ->
      sourcePaths = file.orig.src
      destPath = util.normalizeBuildExtension(util.prefix(file.orig.dest))

      # Create the destination directory
      mkdirp.sync path.dirname(destPath)

      # Adds CoffeeScript file extension to the list of supported extensions
      # automatically. ShampooJS has CoffeeScript support built in. Note that
      # we still need to add the `coffeeify` module to make CoffeeScript work.
      browserifyOptions = {
        extensions: [".coffee"]
      }

      # Create a browserify instance that accepts both .js and .coffee files.
      # Note that Watchify returns a Browserify instance except that it caches
      # making Browserify run a lot faster after the first bundle.
      if options.watch
        browserify = (require 'watchify')(browserifyOptions)
      else
        browserify = (require 'browserify')(browserifyOptions)

      # # Create a watchify instance that accepts both .js and .coffee files.
      # # Watchify returns a Browserify instance except that it caches making
      # # Browserify run a lot faster after the first bundle.
      # watchify = watchifyModule(watchifyOptions)

      # Add all the source paths the .files configuration.
      flattenedSourcePaths = []
      _.each sourcePaths, (sourcePath) ->
        expandedSourcePaths = glob.sync sourcePath
        # if the glob doesn't expand, it will actually return an empty Array
        # instead of the sourcePath. The code below fixes this.
        if expandedSourcePaths.length == 0
          expandedSourcePaths = [util.prefix(sourcePath)]
        _.each expandedSourcePaths, (expandedSourcePath) ->
          expandedSourcePath = util.prefix(expandedSourcePath)
          flattenedSourcePaths.push expandedSourcePath
          browserify.add expandedSourcePath

      # Add the CoffeeScript transform. The CoffeeScript transform is added
      # first so that the other transforms are working on top of JavaScript
      # code instead of CoffeeScript code.
      browserify.transform(coffeeify)

      # Process maps separates our single map configuration into two separate
      # maps. One is an alias map which just maps a name to a path. The other
      # is a shimMap which maps a name to a path and a variable that needs to
      # be pulled out of it. The aliasMap is fed to `aliasify` and the
      # shimMap is fed to `browserify-shim`.
      maps = processMap(options.map)
      aliasMap = maps.aliasMap
      shimMap = maps.shimMap

      # Add browserify-shim only if there are any shim maps
      if !_.isEmpty(shimMap)
        shim = require 'browserify-shim'
        shimOptions = resolveShimOptions(shimMap)
        resolveShimOptions(shimOptions)
        shim(browserify, shimOptions)

      # Add alias support using aliasify plugin if there are any alias maps
      if !_.isEmpty(aliasMap)
        aliasify = require("aliasify").configure
          aliases: aliasMap
        browserify.transform(aliasify)

      # Add BRFS support if requested
      if options.brfs
        browserify.transform('brfs')

      bundleOptions = {
        # The default is to include the source maps
        debug: options.sourceMaps || true
        # These are actually the default values but added here for clarity
        insertGlobals: false   # don't auto insert globals
        detectGlobals: true    # only insert if a global is referenced
      }

      # If we are in watch mode, then we don't need to ever quit so the
      # function just does nothing (noop). If we are not in watch mode, then
      # we need to terminate once all the bundles are completed. The method
      # then just counts the completed bundles and calls quit() when the
      # number of completed bundles matches the total number of bundles.
      if options.watch
        completeBundle = ->
      else
        completeBundle = ->
          completedBundles++
          quit() if completedBundles == numBundles


      # Create a bundle function that gets called whenever a file is updated.
      # We put it in a separate function because we also need to call the
      # bundle once manually and also separately from the callback. If we don't
      # call it once immediately, then watchify doesn't keep the process open
      # (i.e. it immediately exits instead of watching)
      bundle = ->
        browserify.bundle bundleOptions, (err, src) ->
          if err
            grunt.log.error err
            completeBundle()
          else
            fs.writeFile destPath, src, (err) ->
              if err
                grunt.log.error err
                completeBundle()
              else
                console.log "  DONE: #{destPath}."
                console.log ""
                completeBundle()

      # Let the world know that we have started.
      console.log ""
      console.log "----------"
      console.log "Shampoo JS"
      console.log "----------"

      # watch for file changes. When there is one, then we call bundle()
      if options.watch
        browserify.on "update", (ids) ->
          console.log "Shampooing changes:" #  #{id.join(', ')}
          _.each ids, (id) ->
            relativePath = util.rootPath(util.normalizePathDelimiter(path.relative(process.cwd(), id)))
            console.log "  FILE: #{relativePath}"
          # console.log ""
          bundle()
        console.log ""
        console.log "Watching #{sourcePaths} and dependencies forever..."
        console.log ""
        console.log "  CTRL+C to quit."
        console.log ""
      else
        console.log ""
        console.log "Not watching. Running once."
        console.log ""

      # Sometimes the bundle will be working against watchify (i.e. the process
      # will keep looking for file changes forever). Even when we are using
      # watchify, we will still want to run the bundle at the very beginning.
      console.log "Shampooing:" #  #{sourcePaths.join(', ')}
      _.each flattenedSourcePaths, (path) ->
        console.log "  FILE: #{path}"
      # console.log ""
      bundle()