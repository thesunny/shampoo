grunt = require 'grunt'
_ = require 'lodash'
path = require 'path'

argv = process.argv

class ShampooCLI
  constructor: (argv) ->
    @initArgs(_.clone(argv))

  initArgs: (args) ->
    mode = null
    lang = null
    force = null
    names = []
    # shift off the first two arguments because they are just running of this
    # program and not the actual arguments
    args.shift()
    args.shift()
    _.each args, (arg) =>
      if arg == '--init' || arg == '--init-js'
        mode = "init"
        lang = "js"
      else if arg == '--init-coffee'
        mode = 'init'
        lang = 'coffee'
      else if arg == '--force'
        force = true
      else
        names.push arg

    if mode == 'init'
      if lang == 'coffee'
        @copyTemplate('Shampoofile.coffee', force)
      else if lang == 'js'
        @copyTemplate('Shampoofile.js', force)
    else if names.length == 0
      @runFromShampoofile('default')
    else if names.length == 1
      @runFromShampoofile(names[0])

  copyTemplate: (filename, force) ->
    # fs = require 'fs'
    templatePath = __dirname + "/../templates/#{filename}"
    localPath = path.join(process.cwd(), filename)
    if grunt.file.exists(localPath) && !force
      @warn(
        "#{filename} already exists in this directory",
        "To force overwrite, add --force to arguments"
      )
    else
      grunt.file.copy templatePath, localPath
      console.log "Successfully created #{filename}"

  runFromShampoofile: (taskSubName) ->
    # look for both a JavaScript and CoffeeScript file.
    # If both, throw an error.
    # If none, throw an error.
    # If one, then process it.
    jsPath = path.join(process.cwd(), "Shampoofile.js")
    coffeePath = path.join(process.cwd(), "Shampoofile.coffee")
    jsFileExists = grunt.file.exists(jsPath)
    coffeeFileExists = grunt.file.exists(coffeePath)
    if jsFileExists and coffeeFileExists
      @warn "Both 'Shampoofile.js' and 'Shampoofile.coffee' exists.", "Please delete or rename one."
      return
    else if jsFileExists
      shampooPath = jsPath
      ShampoofileOptions = require jsPath
    else if coffeeFileExists
      shampooPath = coffeePath
      ShampoofileOptions = require coffeePath
    else
      @warn "Could not find 'Shampoofile.js' or 'Shampoofile.coffee'"
      return

    # Setup Grunt to run the config
    grunt.initConfig(
      browserifying: ShampoofileOptions
    )
    grunt.loadTasks 'tasks'
    shampooConfig = grunt.config.get('browserifying')
    if shampooConfig[taskSubName]
      grunt.task.run "browserifying:#{taskSubName}"
      grunt.task.start()
    else
      @warn(
        "Could not find a key named '#{taskSubName}' in the Shampoofile at:",
        shampooPath
      )

  warn: (msg) ->
    console.log ""
    console.log "=== WARNING ==="
    _.each arguments, (msg) ->
      console.log msg

shampooCLI = new ShampooCLI(process.argv)