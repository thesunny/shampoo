# grunt-browserifying

The ultimate Grunt Browserify task.

Waits for file changes and automatically builds using Browserify.

  * Uses a cache for super speed (instant builds)
  * CoffeeScript support out of box
  * Alias mappings
  * Shimming
  * Inlining external files

## Includes Popular Browserify Modules

Grunt Browserify Plus works by including the most popular Browserify modules and tools and configures them so that they all work together:

  * Coffeeify
  * Watchify
  * Aliasify
  * Browserify-Shim
  * BRFS


## Getting Started
This plugin requires Grunt `~0.4.2`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-browserifying --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-browserifying');
```


## The Browserifying Grunt Plugin

### Overview
In your project's Gruntfile, add a section named `browserifying` to the data object passed into `grunt.initConfig()`.

Include a `files` Object where:

  * The keys are the destination file for the Browserify build (remember to include the ".js")
  * The value is either a `String` or `Array` of `String` that represents the source files. The source files may be either `.js` or `.coffee` files. Remember to:
    1. Include the extension (.js or .coffee).
    1. Include the "./" part of the path

The source files are relative to the directory from where `grunt` is being run.

Optionally include an `options` Object. See the Options section for more info.

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      // Options go here. See below for options.
    },
    files: {
      './build/path/example.js': './source/path.js'
    },
  },
});
```

#### Running the Grunt Task

Run the grunt task from the command line using:

```
grunt browserify_plus
```


#### CoffeeScript

As mentioned, it works with CoffeeScript files (no configuration required):

```js
grunt.initConfig({
  browserify_plus: {
    options: {},
    files: {
      './build/path/example.js': './source/path.coffee'
                                // .coffee files work
    },
  },
});
```


#### Multiple Source Files

For multiple files, pass in an array (feel free to mix js and coffee files):

```js
grunt.initConfig({
  browserify_plus: {
    options: {},
    files: {
      './build/path/example.js': ['./source/path.coffee', './source/path_2.js']
                               // Array of String for sources works
    },
  },
});
```


#### Multiple Browserify Bundles

You can have multiple builds going on simultaneously:

```js
grunt.initConfig({
  browserify_plus: {
    options: {
    },
    files: {
      // Multiple key/value pairs works to create multiple Browserify bundles
      './build/path/example.js': ['./source/path.coffee', './source/path_2.js']
      './build/path/example-2.js': './source/example-2.js'
    },
  },
});
```




### Options

#### options.alias
Type: `Object`
Default value: `null`

An Object that maps require names to file locations.

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      alias: {
        'underscore': './lib/underscore.js'
      }
    },
    files: {
      ...
    },
  },
});
```

The root directory for the destination (i.e. './lib/underscore.js') is the directory where grunt is being run from.


#### options.shim
Type: `Object`
Default value: `null`

A shim exports a variable set within the JavaScript of that file. For example, underscore sets a "_" variable which we can then export. The same could be done for jQuery.

Note that shim also does aliasing as in `options.alias` above.

```js
grunt.initConfig({
  browserify_plus: {
    options: {
      shim: {
        'underscore': {
          exports: '_',
          path: './lib/underscore.js'
        },
        'jquery': {
          exports: '$',
          path: './lib/jquery.js'
        }
      }
      }
    },
    files: {
      ...
    },
  },
});
```


#### options.debug
Type: `Boolean`
Default value: `false`

When set to `true`, the output will include source maps. This means that when an error is thrown in any browser that supports source maps (e.g. Chrome or Firefox), you will see the original location where the error came from.


#### options.brfs
Type: `Boolean`
Default value: `false`

When set to `true`, calls to `fs.readFileSync(__dirname+'/file.txt')` will have the contents of the file inlined into the JavaScript. To make it all work, you should include the `require 'fs'` in the JavaScript or CoffeeScript file.

```js
fs = require 'fs'
text = fs.readFileSync(__dirname + '/file.txt')
```


#### Future TODO

Here's some features I'd like to add.

  * Merge `options.shim` into `options.alias`: This will simplify creating aliases and shims. Consider the workflow where you start by using an alias and then notice that it requires a shim. You now have to move declaration into the shim section. By merging the two, this will no longer be required.



## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_
