#
# * grunt-browserifying
# * https://github.com/thesunny/grunt-browserifying
# *
# * Copyright (c) 2014 Sunny Hirai
# * Licensed under the MIT license.
# 
"use strict"

fs = require 'fs'
path = require 'path'
watchifyModule = require 'watchify'
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
      debug: false
      brfs: false
      aliasMappings: null
      shim: null
    )

    @files.forEach (file) ->
      sourcePaths = file.orig.src
      destPath = file.orig.dest

      watchifyOptions = {
        extensions: [".coffee"]
      }

      # Create a watchify instance that accepts both .js and .coffee files
      watchify = watchifyModule(watchifyOptions)

      # Add all the source paths
      _.each sourcePaths, (sourcePath) ->
        watchify.add sourcePath

      # Add the CoffeeScript transform
      watchify.transform(coffeeify)

      # Add browserify-shim
      # NOTE: This must be done after the CoffeeScript transform
      if options.shim?
        shim = require 'browserify-shim'
        shimOptions = resolveShimOptions(options.shim)
        resolveShimOptions(shimOptions)
        shim(watchify, shimOptions)

      # Add alias support using aliasify plugin
      aliasify = require("aliasify").configure
        aliases: options.alias
      watchify.transform(aliasify)

      if options.brfs
        watchify.transform('brfs')

      # Create a bundle function that gets called whenever a file is updated
      bundle = ->
        watchify.bundle {
          debug: options.debug
          detectGlobals: options.detectGlobals
          insertGlobalse: options.insertGlobals
        }, (err, src) ->
          if err
            grunt.log.error err
          else
            fs.writeFile destPath, src, (err) ->
              console.log "browserifying done."


      # watchify.on "file", (file, id, parent) ->
      #   console.log "on file:", id

      # watch for file changes. When there is one, then we call bundle()
      watchify.on "update", (id) ->
        console.log "browserifying #{id.join(', ')}"
        bundle()

      console.log "-------------------"
      console.log "grunt-browserifying"
      console.log "-------------------"
      console.log "Watching #{sourcePaths}"
      bundle()

      # if (opts.shim) {
      #   shims = opts.shim;
      #   var noParseShimExists = false;
      #   var shimPaths = Object.keys(shims)
      #     .map(function (alias) {
      #       var shimPath = path.resolve(shims[alias].path);
      #       shims[alias].path = shimPath;
      #       if (!noParseShimExists) {
      #         noParseShimExists = ctorOpts.noParse && ctorOpts.noParse.indexOf(shimPath) > -1;
      #       }
      #       return shimPath;
      #     });
      #   b = shim(b, shims);
      #   if (noParseShimExists) {
      #     var shimmed = [];
      #     b.transform(function (file) {
      #       if (shimmed.indexOf(file) < 0 &&
      #           ctorOpts.noParse.indexOf(file) > -1 &&
      #           shimPaths.indexOf(file) > -1) {
      #         shimmed.push(file);
      #         var data = 'var global=self;';
      #         var write = function (buffer) {
      #           return data += buffer;
      #         };
      #         var end = function () {
      #           this.queue(data);
      #           this.queue(null);
      #         };
      #         return through(write, end);
      #       }
      #       return through();
      #     });
      #   }
      # }



  #   # Iterate over all specified file groups.
  #   @files.forEach (f) ->
      
  #     # Concat specified files.
      
  #     # Warn on and remove invalid source files (if nonull was set).
      
  #     # Read file source.
  #     src = f.src.filter((filepath) ->
  #       unless grunt.file.exists(filepath)
  #         grunt.log.warn "Source file \"" + filepath + "\" not found."
  #         false
  #       else
  #         true
  #     ).map((filepath) ->
  #       grunt.file.read filepath
  #     ).join(grunt.util.normalizelf(options.separator))
      
  #     # Handle options.
  #     src += options.punctuation
      
  #     # Write the destination file.
  #     grunt.file.write f.dest, src
      
  #     # Print a success message.
  #     grunt.log.writeln "File \"" + f.dest + "\" created."
  #     return

  #   return

  # return

#   fs = require 'fs'
# watchify = require 'watchify'
# coffeeify = require 'coffeeify'

# # We are using watchify but I named it browserify because the object behaves
# # just like browserify (except with caching) and the documentation for how
# # to use it is all from browserify.
# browserify = watchify({
#   extensions: [".js", ".coffee"]
# })
# browserify.add "./coffeescripts/snapeditor.coffee"
# browserify.transform coffeeify

# bundle = ->
#   browserify.bundle {
#     debug: true
#     detectGlobals: false
#     insertGlobalse: false
#   }, (err, src) ->
#     fs.writeFile "./build-target/snapeditor.js", src, (err) ->
#     console.log "done."  

# browserify.on "update", (id) ->
#   console.log "bundling #{id.join(', ')}"
#   bundle()

# console.log "start watchify"
# console.log "initial bundle"
# bundle()