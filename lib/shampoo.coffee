# Runs the Shampoofile using Grunt but without actually having to run Grunt
# from the command line.

grunt    = require 'grunt'
_        = require 'lodash'
path     = require 'path'
minimist = require 'minimist'

class ShampooCLI
  constructor: (argv) ->
    @initArgs(_.clone(argv))

  initArgs: (args) ->
    # don't need the first two arguments because that is 'node.js' and 'shampoo.js'
    # and we convert the rest into a plain JavaScript object using minimist.
    argv  = minimist(args.slice(2))
    mode  = null
    lang  = null
    force = null
    watch = true
    names = []

    options =
      force: argv.force || false
      initJavaScript: argv['init-js'] || argv['init'] || false
      initCoffeeScript: argv['init-coffee'] || false
      once: argv['once'] || argv['o'] || false
      files: argv['_']
      dest: argv['_'][0]
      src: argv['_'].slice(1)

    # only do one of these which is why we have a lot of if/else here
    if options.initCoffeeScript
      @copyTemplate 'Shampoofile.coffee', options.force
    else if options.initJavaScript
      @copyTemplate 'Shampoofile.js', options.force
    else if options.files.length == 0
      @runFromShampoofile 'default'
    else if options.files.length == 1
      @runFromShampoofile options.dest[0]
    else
      @runFromArguments(options.files, !options.once)


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

  runFromArguments: (args, watch) ->
    buildPath = args[0]
    sourcePaths = _.toArray(args)
    # shift off the buildPath
    sourcePaths.shift()
    argvOptions = {
      options: {}
      files: {}
    }
    # TODO: Temporarily set this to false for testing. Once I get the tests
    # in place and --once option working, then this should not be hard coded.
    argvOptions.options.watch = watch
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