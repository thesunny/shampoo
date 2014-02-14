# Runs the Shampoofile using Grunt but without actually having to run Grunt
# from the command line.

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
      # If run with --init or --init-js then initialize for Javascript
      if arg == '--init' || arg == '--init-js'
        mode = "init"
        lang = "js"
      # If run with --init-coffee then initialize for CoffeeScript
      else if arg == '--init-coffee'
        mode = 'init'
        lang = 'coffee'
      # If run with --force, then allow initialization to overwrite existing
      # Shampoofile
      else if arg == '--force'
        force = true
      # For everything else, we just push the argument onto the list of names.
      # The first name found is always the build destination.
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
    else
      console.log '782374893728947328947328974893'
      console.log names
      @runFromArguments(names...)

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
      shampoo: ShampoofileOptions
    )
    shampooConfig = grunt.config.get('shampoo')
    if shampooConfig[taskSubName]
      @runTask("shampoo:#{taskSubName}")
    else
      @warn(
        "Could not find a key named '#{taskSubName}' in the Shampoofile at:",
        shampooPath
      )

  runFromArguments: (buildPath) ->
    sourcePaths = _.toArray(arguments)
    # shift off the buildPath
    sourcePaths.shift()
    argvOptions = {
      files: {}
    }
    argvOptions.files[buildPath] = sourcePaths
    grunt.initConfig(
      shampoo:
        argv: argvOptions
    )
    @runTask("shampoo:argv")

  # Loads the tasks defined for this project in ./tasks and then runs the
  # task with the given taskName
  runTask: (taskName) ->
    grunt.loadTasks path.join(__dirname, '../tasks')
    grunt.task.run taskName
    grunt.task.start()

  # Outputs a nicely formatted warning message to the console.
  warn: (msg) ->
    console.log ""
    console.log "=== WARNING ==="
    _.each arguments, (msg) ->
      console.log msg

shampooCLI = new ShampooCLI(process.argv)