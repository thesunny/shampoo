# grunt-browserifying

The ultimate Grunt Browserify task.

  * Run once or watch files for changes
  * Uses a cache for super speed (instant builds)
  * CoffeeScript support built in
  * Alias mappings
  * Shim non CommonJS files
  * Super simple configuration and good defaults
  * More...


## Quick Start
If you already know Grunt, for basic usage create a `Gruntfile.js` as below filling in your destination path and source path.

```
// Gruntfile.js
module.exports = function(grunt) {
  grunt.initConfig({
    browserifying: {
      files: {
        './build/dest/path.js': './source/path.js'
      },
    },
  });
  grunt.loadNpmTasks('grunt-browserifying');
}
```

Then from your console:
```
grunt browserifying
```

This will start the task and watch the source file and all of its require'd dependencies for changes. It will rebuild when a file change is detected. It uses caching so its very fast. To quit watching, use `CTRL-C`.



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
  browserifying: {
    options: {
      // See the options sections for all options.

      // popular option watches for file changes and updates only the changed
      // files. If watch is missing or set to false, browserifying will only
      // bundle the files once and exit.
      watch: true 
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

It works with CoffeeScript files (no configuration required):

```js
grunt.initConfig({
  browserifying: {
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
  browserifying: {
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
  browserifying: {
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

All options:

```js
grunt.initConfig({
  browserifying: {
    options: {
      watch: false, // watch files for changes with caching (default true)
      map: {
        'underscore': './lib/underscore.js',
        'jquery': {
          exports: '$',
          path: './lib/jquery.js',
        }
      },
      sourceMaps: true,     // enable source maps (default true)
      brfs: true            // enable inlining files (default false)
    }
    },
    files: {
      ...
    },
  },
});
```


#### options.map

Type: `Object`
Default value: `{}`

A map allows you to:

* alias: Require files from any location using an alias
* shim: Use a non-CommonJS JavaScript file with `require`

##### options.map - alias

```js
// a map allows you to do this
require 'underscore'
```

Instead of this
```js
// don't do this anymore
require '../node_modules/underscore/underscore.js'
```

Configure maps like this:

```js
grunt.initConfig({
  browserifying: {
    options: {
      map: {
        'underscore': './lib/underscore.js'
      }
    },
    files: {
      ...
    },
  },
});
```

##### options.map - shim

You can also use a shim inside the map.

A shim allows you to use JavaScript files that are not designed for use with CommonJS.

In a CommonJS file, we export a variable by assigning it to `module.exports` like this:

```js
// code goes here
module.exports = someVariable;
```

JavaScript files that don't conform to CommonJS, don't have a `module.exports` assignment. Normally we would have to modify the JavaScript file just to add `module.exports` to make it work with Browserify.

Instead, we can use a shim. We just tell that shim what variable to export. In the example above, that variable would be `someVariable`. For jQuery, it would be `$` or `jQuery` (both reference the same object).

Here is how to use map to create a shim:

```js
grunt.initConfig({
  browserifying: {
    options: {
      map: {
        // jQuery with a shim
        'jquery': {
          exports: '$',
          path: './lib/jquery.js'
        },
        // we can mix unshimmed maps in as well like below
        'underscore': './lib/underscore.js'
      }
    },
    files: {
      ...
    },
  },
});
```

Now we can do:

```js
// this works now
$ = require('jquery');
```


#### options.sourceMaps
Type: `Boolean`
Default value: `true`

When set to `true`, the output will include source maps. This means that when you are running the JavaScript code and there is an error you will see the error coming from the original file (not the bundle one). Your browser must support source maps (e.g. Chrome, Firefox, Safari).

```js
grunt.initConfig({
  browserifying: {
    options: {
      sourceMaps: false    // disable source maps
    },
    files: {
      ...
    },
  },
});
```


#### options.brfs
Type: `Boolean`
Default value: `false`

When set to `true`, calls to code like `fs.readFileSync(__dirname + '/file.txt')` will have the contents of the file inlined into the JavaScript.

Remember to include `require 'fs'` in the JavaScript or CoffeeScript file.

```js
fs = require 'fs'
text = fs.readFileSync(__dirname + '/file.txt')
```


## Roadmap

Here's some features I'd like to add.

  * **gulp:** Make it work with gulp
  * **command line:** Make it work from the command line
  * **unit tests:** Unit test everything
  * **dev and production modes:** Create sensible defaults for a 'production' mode and a 'development' mode. For example, debug mode should have sourceMaps: true and watching for changes: true while development mode should have no sourceMaps and only do the build one.
  * **minification and obfuscation:** Add minification and obfuscation options with good defaults



## Contributing

* **CoffeeScript:** Browserifying is written in CoffeeScript.

* **Comments:** Please write a lot of comments. Since there are a lot of modules that get included (being that the purpose of Browserifying is to bring important modules together), it's important to comment everything that is going on in the code.

* **Descriptive Variable Names:** Use long descriptive variable names rather than short ones so that it's easy for anybody to look at the source code and understand what's going on.

We accept and encourage commits.


## Release History

February 2, 2014
* Added a `.watch` option so the same Grunt task can be used to do a single build (e.g. for production) or watching and continuously building (e.g. for development)
* Merged `.aliasMappings` and `.shim` options into a single `.map` option. Easier to remember the name and its easier to convert an alias into a shim because you don't have to move the configuration options.
* Added `brfs` support.
* Renamed `.debug` option to `.sourceMaps` to be more intuitive.
* Renamed library from `grunt-browserify-plus` to `grunt-browserifying`



## Thanks To

Browserifying works by including the most popular Browserify modules and tools and configures them so that they all work together.

Browserifying is really just a manager over a lot of important work contributed to the following projects:

  * Browserify
  * Coffeeify
  * Watchify
  * Aliasify
  * Browserify-Shim
  * BRFS
